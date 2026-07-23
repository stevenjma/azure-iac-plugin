---
name: cleanup-secrets
description: >
  Terraform terraform-cleanup Pass 3.5 — handle secrets and write-only fields. Generates a
  secrets.auto.tfvars.example template, wires ephemeral (TF >= 1.10) or sensitive
  variables, and surfaces a mandatory user warning. Invoked by terraform-cleanup
  orchestrator; can run standalone.
license: MIT
---

## Goal

Every `null # sensitive` placeholder in the working set is replaced with a typed
variable; the user is told exactly which values they must supply before `terraform
apply` will succeed.

## Decision: ephemeral vs sensitive

```
terraform version >= 1.10 AND azurerm >= 4.x
├─ YES → ephemeral "variable" (never in state)
└─ NO  → variable { sensitive = true } + lifecycle { ignore_changes = [<field>] }
```

## Procedure

1. Scan all `.tf` files for `null # sensitive` and any field the provider schema marks
   as `Sensitive: true` + `Computed: false`.
2. For each match, determine if the secret is **conditionally required** (e.g.
   `account_key` only when `service_data_auth_identity = "None"`).
3. Choose ephemeral vs sensitive based on detected Terraform + azurerm versions.
4. Generate `secrets.auto.tfvars.example` with one line per secret and a header:
   ```hcl
   # ⚠️  COPY this to secrets.auto.tfvars and fill in real values.
   # ⚠️  NEVER commit secrets.auto.tfvars to source control.
   storage_account_key = ""
   sql_admin_password  = ""
   ```
5. Add a `.gitignore` recommendation (do not write `.gitignore` — recommend in the
   summary).
6. Wire the variable into every resource where the secret was a placeholder.
7. For Terraform < 1.10: add `lifecycle { ignore_changes = [<field>] }` to each
   resource that uses a sensitive write-only attribute.
8. Load `references/secrets-warning.md` and surface its mandatory warning table.

## Acceptance Criteria (mandatory)

Write `<workdir>/.cleanup/secrets.json`:

```json
{
  "pass": "3.5-secrets",
  "status": "complete",
  "strategy": "ephemeral",
  "terraform_version": "1.12.2",
  "secrets_identified": [
    { "variable": "storage_account_key", "needed_by": 6, "condition": "always" },
    { "variable": "sql_admin_password",  "needed_by": 1, "condition": "always" }
  ],
  "secrets_auto_tfvars_example_written": true,
  "warning_surfaced": true
}
```

The pass is **not complete** unless:
- `secrets.auto.tfvars.example` exists at the workdir root.
- `warning_surfaced == true` (user has seen the table).
- `secrets_identified` covers every `null # sensitive` in the codebase.

## Conditional secrets reference

| Secret | Required when | Not required when |
|--------|---------------|-------------------|
| `account_key` | `service_data_auth_identity = "None"` | `WorkspaceSystemAssignedIdentity` |
| `admin_password` | `disable_password_authentication = false` | SSH key auth only |
| `client_secret` | Service principal auth | Managed identity auth |

## Non-goals

- Variable extraction for non-secrets (`cleanup-variables`).
- Validation loop (`cleanup-validate`).
- Writing `.gitignore` (recommendation only).
