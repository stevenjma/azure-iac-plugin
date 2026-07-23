---
name: cleanup-organize
description: >
  Use this skill only during terraform-cleanup Pass 3.4, or when the user explicitly asks to
  organize exported Terraform. Split flat HCL by domain, replace generated resource labels with
  semantic names, and preserve every renamed state address with a moved block.
license: MIT
---

## Goal

Reach a layout matching the target structure below, with every resource address using
a semantic name derived from the Azure resource (not `res-1`, `res-2`, `example`).

## Target Layout

```
project/
├── main.tf              # Core: resource group, identity (≤ 5 resources)
├── variables.tf         # Owned by cleanup-variables
├── outputs.tf           # Useful outputs
├── providers.tf         # Provider config + required_providers
├── locals.tf            # Owned by cleanup-consolidate when present
├── networking.tf        # VNets, subnets, NSGs, route tables, private endpoints
├── compute.tf           # VMs, VMSS, container instances, App Service
├── storage.tf           # Storage accounts, containers, shares
├── database.tf          # SQL, Cosmos, Redis
├── security.tf          # Key Vault, managed identities, RBAC
├── monitoring.tf        # Log Analytics, alerts, diagnostic settings
└── terraform.tfvars.example
```

Skip a file if no resource belongs in it. Add a file outside the table only with an
explicit reason (e.g. `machine_learning.tf` if 5+ ML resources exist).

## Naming Rules

- `snake_case`, descriptive, derived from the Azure resource name.
- Strip random suffixes added by aztfexport (`-abc123`) unless they disambiguate.
- Deduplicate with `_2`, `_3` suffixes if the stripped name collides.
- Never `res1`, `example`, `default` (except the literal Azure `"default"` subnet name).

## Procedure

1. Read the current file inventory and resource addresses.
2. For each resource, determine the target file from its `type` (see mapping above).
3. For each `res-N` address, compute the semantic name from the Azure `name` argument.
4. For every rename, emit a `moved {}` block in the destination file:
   ```hcl
   moved {
     from = azurerm_storage_account.res-3
     to   = azurerm_storage_account.demo
   }
   ```
5. Physically move the resource block to the destination file.
6. Update every reference (`resource.type.old_name.attr`) across all files.
7. Run `terraform validate` then `terraform plan`; expect `0 to add, 0 to destroy` after
   `moved {}` blocks settle.

## Acceptance Criteria (mandatory)

Write `<workdir>/.cleanup/organize.json`:

```json
{
  "pass": "3.4-organize",
  "status": "complete",
  "files_created": ["networking.tf", "storage.tf", "monitoring.tf"],
  "resources_renamed": [
    { "from": "azurerm_storage_account.res-3", "to": "azurerm_storage_account.demo" }
  ],
  "res_n_remaining": 0,
  "moved_blocks_emitted": 12,
  "plan_destroys": 0
}
```

The pass is **not complete** unless:
- `res_n_remaining == 0` (or each remaining entry has a justified `reason`).
- `plan_destroys == 0`.

## Non-goals

- `for_each` consolidation (`cleanup-consolidate`).
- Reference injection (`cleanup-references` ran earlier).
- Validation loop (`cleanup-validate`).
