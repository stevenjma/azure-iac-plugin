# Terraform cleanup constraint map schema

Phase 2 (doc enrichment) produces a constraint map per resource type. The sub-skills
read this map; the orchestrator builds it.

## Schema

```json
{
  "azurerm_key_vault": {
    "enum_fields": {
      "access_policy.certificate_permissions": ["Backup", "Create", "Delete", "..."]
    },
    "id_format": "/subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.KeyVault/vaults/{name}",
    "write_only_fields": ["access_policy.*.application_secret"],
    "conditional_requirements": {},
    "cross_resource_id_format": {},
    "deprecated_attributes": ["soft_delete_enabled"]
  }
}
```

## How sub-skills use it

| Sub-skill | Field read | Purpose |
|---|---|---|
| `cleanup-references` | `cross_resource_id_format` | Pick `.id` vs `.resource_manager_id` vs interpolation |
| `cleanup-prune` | `enum_fields` | Empty-string default replacement (Rule 1.6) |
| `cleanup-prune` | `deprecated_attributes` | Remove deprecated fields |
| `cleanup-secrets` | `write_only_fields` | Identify sensitive write-only fields |
| `cleanup-validate` | All of the above | Categorize drift |

## Enum extraction technique

Consult the provider schema for each top-level block (e.g. `site_config`) — from the
**Terraform Registry** docs or `terraform providers schema -json`. Parse each field's
`description` for:

- `"Possible values include \`X\`, \`Y\`, and \`Z\`"` → enum constraint.
- `"Defaults to \`X\`"` → default value for empty-string replacement.

Never mix providers: read the azurerm schema for azurerm code, the azapi schema for azapi code.
