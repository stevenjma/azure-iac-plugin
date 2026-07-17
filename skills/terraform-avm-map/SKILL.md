---
name: terraform-avm-map
description: >
  terraform-avm-compose Phase 3.1 — turn coverage.json into the Terraform module-call skeleton and
  the import wiring that binds live resources to state. Emits one `module` block per resolved AVM
  type (pinned `source = "Azure/avm-res-*/azurerm"` + `version`), a confirmed fallback per gap, and
  an `import` block per module-managed live resource so plan can reach zero-diff. Writes map.json.
license: MIT
---

## Goal

Materialize the resolver's decision into a valid Terraform skeleton and — crucially for brownfield —
the **import blocks** that adopt existing Azure resources into the module's state addresses. Without
imports, `terraform plan` would propose to *create* resources that already exist. No variable values
are wired here (that is 3.2); this pass owns **module structure, version pinning, and import wiring**.

## Preconditions

- `<workdir>/.avm/coverage.json` exists (from `avm-module-resolver`) with `resolved[]` + `gaps[]`.
- `<workdir>/.avm/intake.json` and `checklist.json` exist (orchestrator ran Phase 1).
- Every `gap` has a confirmed `fallback` (`raw-resource` | `defer`; Terraform AVM has no child
  modules, so `child-of-parent` becomes a folded input, handled in 3.2).
- Recommended: `<workdir>/.avm/schema/<module>.json` lists each module's managed resource addresses.
- This is pass 3.1 — it runs first.

## Procedure

1. **Emit a module block per `resolved` entry**, one per live resource instance (not per type),
   using the pinned `source`/`version` from `coverage.json` verbatim (never re-derive the version):

   ```hcl
   module "storage_account_sa1" {
     source  = "Azure/avm-res-storage-storageaccount/azurerm"
     version = "0.7.3"
     # variables wired by terraform-avm-inputs (3.2)
   }
   ```

   Give each a stable label from the live resource name (kebab/snake). Record the label ↔
   live-resource-id mapping (3.2, imports, and validate rely on it).
2. **Emit `import` blocks that bind live resources to module-internal addresses.** For each module,
   read its managed resource addresses from the schema and pair each with the matching live resource
   ID from the oracle:

   ```hcl
   import {
     to = module.storage_account_sa1.azurerm_storage_account.this
     id = "/subscriptions/…/resourceGroups/rg1/providers/Microsoft.Storage/storageAccounts/sa1"
   }
   ```

   AVM modules commonly name the primary resource `.this`; child/sub-resources have their own
   addresses (e.g. `azurerm_storage_container.this["blob"]`). Emit an import for **every** live
   resource the module will manage, or plan will show spurious create/destroy. When an address is
   uncertain, record it in `map.json.import_uncertain` for the validate loop to resolve from the
   first plan's proposed addresses.
3. **Handle folded children via imports too.** Terraform AVM folds children (subnets, KV secrets)
   into parent inputs (wired in 3.2) but they still surface as module-internal addresses — emit an
   import block for each so the parent module adopts them rather than recreating.
4. **Emit fallback stubs per `gap`:**
   - `raw-resource` → a plain `resource` block placeholder (commented TODO for 3.2) **plus** its own
     `import` block binding the live ID to the raw address.
   - `defer` → no block; list in `map.json.deferred` so validate does not expect it in plan.
5. **Add the `terraform`/`required_providers`/`provider "azurerm"` blocks** (features {} required)
   so `terraform init` can run. Do not add variables/outputs beyond this — that is 3.2/3.3.
6. **`terraform init`** to fetch modules and confirm sources resolve. A failed module download means
   the pinned version is wrong — re-run the resolver's version resolution; never float the version.

## Guardrails

- Never re-derive a module name or version — read both from `coverage.json`.
- Never invent a module for a gap. A gap without a confirmed fallback blocks the pass.
- **Every module-managed live resource must have an `import` block.** A missing import is the #1
  cause of brownfield plan churn.
- Never point two different types at the same module source.
- Never emit a literal secret (none belong in import IDs or module blocks anyway).

## BEFORE (coverage.json excerpt)

```json
{ "resolved": [ { "type": "Microsoft.Storage/storageAccounts",
    "source": "Azure/avm-res-storage-storageaccount/azurerm", "version": "0.7.3", "status": "Available" } ],
  "gaps": [ { "type": "Microsoft.Synapse/workspaces", "status": "Proposed", "fallback": "raw-resource" } ] }
```

## AFTER (main.tf skeleton)

```hcl
module "storage_account_sa1" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.7.3"
  # 3.2 wires from .avm/harvest/sa1.json
}

import {
  to = module.storage_account_sa1.azurerm_storage_account.this
  id = "/subscriptions/…/resourceGroups/rg1/providers/Microsoft.Storage/storageAccounts/sa1"
}

# GAP: Microsoft.Synapse/workspaces AVM module is Proposed in Terraform (fallback: raw-resource).
# resource "azurerm_synapse_workspace" "ws1" { ... }  # 3.2 fills; import block below
```

## Acceptance Criteria

Write `<workdir>/.avm/map.json`:

```json
{
  "pass": "3.1-map",
  "status": "complete",
  "modules_emitted": [
    { "label": "storage_account_sa1", "type": "Microsoft.Storage/storageAccounts",
      "source": "Azure/avm-res-storage-storageaccount/azurerm", "version": "0.7.3",
      "liveId": "/subscriptions/…/sa1" }
  ],
  "import_blocks": [
    { "to": "module.storage_account_sa1.azurerm_storage_account.this", "id": "/subscriptions/…/sa1" }
  ],
  "import_uncertain": [],
  "fallbacks": [ { "type": "Microsoft.Synapse/workspaces", "fallback": "raw-resource" } ],
  "deferred": [],
  "version_pins_from_coverage": true,
  "init": "pass"
}
```

Not complete unless: every `resolved` type has a module block with pinned `source`/`version`, every
module-managed live resource has an `import` block (or is listed in `import_uncertain`), every `gap`
is a confirmed fallback (or in `deferred`), `terraform init` succeeded, and `checklist.json` pass
`3.1-map` is `complete`.

## Non-goals

- Wiring variable values (3.2). Splitting files (3.3). `sensitive` vars / Key Vault (3.4). Running
  plan (4). Resolving coverage or versions (that was `avm-module-resolver`).
