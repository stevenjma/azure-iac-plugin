---
name: bicep-avm-inputs
description: >
  bicep-avm-compose Phase 3.2 — wire harvested live config (the export oracle) into each AVM module's
  parameters, and reconcile every place the module's AVM default differs from live config into an
  explicit adopt|pin decision. This is the crown jewel of the AVM lane. Writes inputs.json and
  reconciliation.json.
license: MIT
---

## Goal

Map the config oracle (`.avm/harvest/*.json`) onto each module's input surface so the composed
Bicep reproduces the live resource — **except** where the operator deliberately adopts an AVM
default that is more secure/idiomatic than what is live. Every such difference is recorded in a
**reconciliation ledger** with an explicit `adopt` (take the AVM default) or `pin` (force the live
value) decision. This ledger is what `bicep-avm-validate` Gate D checks the what-if against.

## Preconditions

- `map.json` (3.1) reports `complete`; the module skeleton exists in `main.bicep`.
- `<workdir>/.avm/harvest/*.json` exists (one per live resource; from `brownfield-avm-adopt` 1.3).
- Per-module input schemas exist at `<workdir>/.avm/schema/<module>.json` (recommended) OR are
  fetched on demand from the module's `RepoURL`.
- `quality_target` is known from intake (`faithful` = pin all diffs; `uplift` = adopt safe diffs).

## The two-column problem

For each module you are reconciling **three** views of every property:

| View | Source |
|---|---|
| **Live** | `.avm/harvest/<res>.json` (the oracle — what Azure actually has) |
| **AVM default** | module input schema default (what the module sets if you omit the param) |
| **Chosen** | what you write into `params` |

`Chosen` defaults to `Live` (faithful). You only diverge to the AVM default when `quality_target`
is `uplift` AND the default is a safe posture improvement AND you log it as `adopt`.

## Reconciliation rules (A1.x–A5.x)

These are the rules the ledger's `rule` field cites — Gate D (in `bicep-avm-validate`) requires every
`adopt` entry to name one, and `bicep-avm-compose` routes drift back here. Apply them when projecting
the oracle onto module params (step 2 below):

- **A1.x — direct scalars.** Live ARM scalar maps 1:1 to a same-meaning module param
  (`minimumTlsVersion`, `skuName`). Pin the live value unless uplifting.
- **A2.x — renamed / reshaped.** ARM property whose module param has a different name or shape
  (ARM `supportsHttpsTrafficOnly` → the module's HTTPS-only/WAF-managed param). Map by reading the
  schema, never by ARM path.
- **A3.x — nested objects.** ARM nested block → the module's object param (network ACLs, identity,
  encryption). Wire the whole object; don't blind-copy the ARM body.
- **A4.x — collections.** ARM child collections → the module's array param (containers, subnets,
  secrets), keyed by name.
- **A5.x — safe-default adopt.** Only under `uplift`: when the AVM default is a safe posture
  improvement (TLS 1.2 min, public network access disabled, infra encryption on), adopt the default
  and log an `adopt` entry with live, default, and reason. Anything functional (SKU, capacity,
  region) is always **pinned**, never adopted.

## Procedure

1. **Load the module input schema** for each module block from 3.1. Identify: required params,
   param names/types, allowed enums, secure params, and each param's **AVM default**.
2. **Project the oracle onto inputs.** For each module, read its `.avm/harvest/<res>.json` and map
   live properties to the module's param names — AVM param names are curated, not 1:1 with ARM
   property paths — e.g. ARM `properties.encryption.services.blob.enabled` → module
   `blobServices`/`requireInfrastructureEncryption` inputs. Map by reading the module schema; do not
   blind-copy ARM JSON (Rules A1.x–A4.x).
3. **Wire required params first** (`name`, `location`, and each module's required set). Never leave
   a required param unset — a missing required input fails compile.
4. **Reconcile every AVM-default-vs-live difference.** For each param where the live value differs
   from the module's AVM default:
   - `faithful` target → **pin**: write the live value explicitly into `params`. Record a `pin`
     entry (so validate expects zero what-if drift there).
   - `uplift` target → if the AVM default is a safe improvement (e.g. TLS 1.2 min, public network
     access disabled, infra encryption on), **adopt**: omit the param (or set the AVM default) and
     record an `adopt` entry (Rule A5.x) with a `reason` and the live→default delta. Otherwise **pin**.
   - **Never silently adopt.** An unlogged divergence from live is a defect Gate D will catch.
5. **Fold child resources into parent inputs.** For every `map.json.folded_children`, wire the
   child's live config into the parent module's array/object input (e.g. Key Vault `secrets`,
   subnets into `virtual-network`), not a separate module. Pull the child config from its own
   `.avm/harvest/<child>.json`.
6. **Cross-reference by symbol, not literal ID.** Where a module input needs another in-scope
   resource's ID, reference the module output (`storageAccount.outputs.resourceId`) so Bicep infers
   `dependsOn` — never paste a literal `/subscriptions/…` ID.
7. **Defer secrets.** Any secret-bearing input (keys, passwords, connection strings) is flagged in
   `secrets_deferred` for 3.4 — do NOT write the literal value; leave a placeholder param reference.
8. **Fill fallback stubs from the oracle too.** For `raw-resource` gaps from 3.1, populate the raw
   `resource` block from `.avm/harvest/<res>.json` (same oracle, raw shape).

## Guardrails

- `Chosen` defaults to `Live`. Every deviation to an AVM default is an `adopt` ledger entry with a
  `reason` — no exceptions.
- Never blind-copy ARM `properties.*` into module params — AVM input names differ; map via the
  module schema.
- Never write a literal secret. Never paste a literal resource ID for a cross-reference.
- Do not set a param to its own AVM default value redundantly for a `faithful` diff — pin means the
  *live* value, which by definition differs from the default.
- Wire required params for every module or the pass is incomplete.

## Acceptance Criteria

Write `<workdir>/.avm/inputs.json`:

```json
{
  "pass": "3.2-inputs",
  "status": "complete",
  "modules_wired": [
    { "symbol": "storageAccount", "required_params_set": ["name"], "params_wired": 11,
      "folded_children": 0, "secrets_deferred": ["primaryKey"] }
  ],
  "cross_references_symbolic": 3,
  "raw_fallbacks_filled": 1,
  "reconciliation_artifact": "reconciliation.json"
}
```

And write the ledger `<workdir>/.avm/reconciliation.json`:

```json
{
  "schema_version": 1,
  "quality_target": "faithful",
  "entries": [
    { "module": "storageAccount", "param": "minimumTlsVersion",
      "live": "TLS1_0", "avm_default": "TLS1_2", "chosen": "TLS1_0",
      "decision": "pin", "reason": "faithful reproduction; live is TLS1_0" },
    { "module": "storageAccount", "param": "allowBlobPublicAccess",
      "live": true, "avm_default": false, "chosen": false,
      "decision": "adopt", "reason": "uplift: AVM secure default disables public blob access",
      "rule": "A5.2" }
  ]
}
```

Not complete unless: every module's required params are set, every live-vs-AVM-default difference
has a `reconciliation.json` entry with a `decision` and `reason`, no literal secret or literal
cross-reference ID was written, `folded_children` were wired into parents, and `checklist.json`
pass `3.2-inputs` is `complete`.

## Non-goals

- Splitting into files (3.3). Declaring `@secure()` / Key Vault wiring (3.4). Running what-if (4).
- Choosing modules or versions (that was 3.1 / the resolver).
