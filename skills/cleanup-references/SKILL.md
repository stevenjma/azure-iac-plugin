---
name: cleanup-references
description: >
  Terraform terraform-cleanup Pass 3.1 — replace literal Azure resource IDs, subnet IDs, key vault IDs,
  and resource names with cross-resource references (resource.type.name.id). Invoked by the
  terraform-cleanup orchestrator; can also run standalone on a single file.
license: MIT
---

## Goal

Eliminate every literal Azure resource ID / name in the working directory that has a
matching `resource` declaration in the same set.

## Procedure

1. Build a map of every resource in the working directory:
   `{ "<azure_id>": "<terraform_address>", "<azure_name>": "<terraform_address>.name" }`.
2. Scan every `.tf` file (excluding `variables.tf`, `outputs.tf`, `terraform.tfvars*`) for:
   - Literal subscription/resource IDs (`/subscriptions/...`)
   - Literal resource names quoted as string values
3. For each hit:
   - If a matching resource exists in the map → replace with the reference expression.
   - Use the constraint map (from terraform-cleanup orchestrator) to pick the correct attribute
     (`.id` vs `.resource_manager_id` vs string interpolation — see translation skill Rule 5.x).
4. Re-scan and confirm zero literal IDs remain in resource bodies (provider block excepted).

## Acceptance Criteria (mandatory, machine-checkable)

Write `<workdir>/.cleanup/references.json`:

```json
{
  "pass": "3.1-references",
  "status": "complete",
  "replacements": [
    { "file": "main.tf", "line": 42, "from": "/subscriptions/.../subnets/default", "to": "azurerm_subnet.default.id" }
  ],
  "literal_ids_remaining": 0,
  "literal_ids_remaining_locations": []
}
```

The pass is **not complete** unless:
- `literal_ids_remaining == 0` **OR**
- every remaining literal is justified in `literal_ids_remaining_locations` with a `reason`
  (e.g. `"resource not in working set"`, `"cross-subscription reference"`).

## BEFORE / AFTER

```hcl
# BEFORE
resource "azurerm_private_endpoint" "example" {
  subnet_id = "/subscriptions/abc/.../subnets/default"
}

# AFTER
resource "azurerm_private_endpoint" "example" {
  subnet_id = azurerm_subnet.default.id
}
```

## Non-goals

- Variable extraction (that's `cleanup-variables`).
- Renaming `res-N` → semantic names (that's `cleanup-organize`).
- Anything in `terraform.tfvars` or `variables.tf`.

## Guardrails

- Never invent a resource address that doesn't exist in the working set.
- Preserve string interpolation when the target attribute is documented as path-sensitive
  (e.g. `azurerm_storage_share.id` uses `/shares/` but ML datastores expect `/fileshares/` —
  see translation skill Rule 5.1).
