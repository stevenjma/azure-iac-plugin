---
name: terraform-avm-inputs
description: >
  terraform-avm-compose Phase 3.2 (crown jewel) — project the harvested config oracle onto each AVM
  module's variables, folding child resources into parent inputs, and reconcile every live-vs-AVM-
  default difference into an explicit adopt|pin decision. Writes inputs.json + reconciliation.json.
license: MIT
---

## Goal

Turn live Azure configuration into faithful (or deliberately uplifted) AVM module **variable
assignments**. This is where an AVM composition earns its keep: the module owns the resource
plumbing, but the operator's real config must survive the round-trip. Every value is one of three
views, and every divergence is reconciled on the record:

- **Live** — the value the oracle harvested from ARM (`.avm/harvest/<res>.json`).
- **AVM default** — what the module produces if the variable is omitted (often a WAF-secure default).
- **Chosen** — what we write, with a logged `adopt` | `pin` decision and a rule citation.

## Preconditions

- Pass 3.1 (`terraform-avm-map`) reports `complete`; `map.json` module labels exist.
- `<workdir>/.avm/harvest/*.json` (oracle) and, ideally, `<workdir>/.avm/schema/<module>.json`
  (variable schemas + defaults) exist.
- `intake.json.quality_target` ∈ {`faithful`, `uplift`}.

## Procedure

1. **Load the oracle** for each module's live resource. Apply the reconciliation **Rules A1.x–A5.x
   below** for every ARM-property → module-variable mapping; do not guess variable names — read the
   schema.
2. **Translate ARM → variables** (reconciliation rules):
   - A1.x direct scalars (`minimum_tls_version`, `account_tier`).
   - A2.x renamed/reshaped (ARM `supportsHttpsTrafficOnly` → module `https_traffic_only_enabled`
     or the module's WAF-managed equivalent).
   - A3.x nested objects → the module's object/`optional()` variables (network rules, identity).
   - A4.x collection/`for_each` inputs (containers, subnets).
3. **Fold children into parent inputs** (Terraform AVM has no child modules). Map each child live
   resource to the parent module's collection variable — e.g. KV `secrets`, VNet `subnets`, storage
   `containers` — keyed by name. Its `import` block (from 3.1) adopts the underlying address.
4. **Reconcile against AVM defaults.** For every variable where **live ≠ AVM default**, record a
   ledger entry and decide by quality target:
   - `faithful` → **pin** the live value (set the variable explicitly). `chosen == live`.
   - `uplift` → **adopt** the AVM default only when it is a safe security posture improvement
     (Rule A5.x), logging live, default, and reason. `chosen == avm_default`. Anything ambiguous or
     functional (SKU, capacity, region) is always **pinned**, never adopted.
   Every entry carries `module,label,variable,live,avm_default,chosen,decision,reason,rule`.
5. **Symbolic cross-references.** Wire inter-module references via module outputs
   (`module.law.resource_id`), never literal resource IDs. Record unresolved refs for validate.
6. **Defer secrets.** Flag secret-shaped variables (`administrator_login_password`, `secrets`,
   keys) into `inputs.json.secrets_deferred` for 3.4. Never pin a harvested secret value here.
7. **Prune to intent.** Only set variables that diverge from the AVM default or are required.
   Leaving a variable unset to inherit a WAF-secure default is the point of AVM — do not restate
   defaults (that is drift noise, not fidelity).

## Guardrails

- Never invent a variable name — read the module schema (3.1 fetched it).
- Never pin a secret literal (3.4 owns secrets).
- Never adopt an AVM default for a functional/behavioral change (SKU, capacity, replication,
  region) — only for a security-posture improvement, only under `uplift`.
- Every live-vs-default divergence must appear in `reconciliation.json` — silent divergence is the
  failure mode this pass exists to prevent; validate Gate D cross-checks it.
- Cross-refs are symbolic (`module.*` outputs), never literal IDs.

## AFTER (module inputs)

```hcl
module "storage_account_sa1" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.7.3"

  name                = "sa1"
  location            = "eastus"
  resource_group_name = var.resource_group_name

  # pinned from live (faithful)
  account_replication_type = "LRS"
  # adopted AVM secure default under uplift — see reconciliation.json (Rule A5.2)
  # public_network_access_enabled left unset → module default (false)

  containers = {
    data = { name = "data", public_access = "None" }  # folded child; imported in 3.1
  }
}
```

## Acceptance Criteria

Write `<workdir>/.avm/inputs.json` and `<workdir>/.avm/reconciliation.json`.

`inputs.json`:

```json
{
  "pass": "3.2-inputs", "status": "complete",
  "modules_wired": [ { "label": "storage_account_sa1", "variables_set": 6,
    "children_folded": 1, "unresolved_refs": [] } ],
  "secrets_deferred": [ { "label": "sql_server_s1", "variable": "administrator_login_password" } ]
}
```

`reconciliation.json`:

```json
{
  "quality_target": "faithful",
  "entries": [
    { "module": "storage_account_sa1", "variable": "account_replication_type",
      "live": "LRS", "avm_default": "ZRS", "chosen": "LRS", "decision": "pin",
      "reason": "faithful: preserve live replication", "rule": "A3.1" }
  ]
}
```

Not complete unless every wired module's live config is projected to variables, every child is
folded into a parent input, every live-vs-AVM-default divergence has a `reconciliation.json` entry
with a decision + rule, no secret literal is present, cross-refs are symbolic, and `checklist.json`
pass `3.2-inputs` is `complete`.

## Non-goals

- Module structure / imports (3.1). File layout (3.3). Secret handling (3.4). Plan (4).
