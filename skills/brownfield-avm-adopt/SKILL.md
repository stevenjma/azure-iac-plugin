---
name: brownfield-avm-adopt
description: >
  Bring existing Azure infrastructure under IaC as Azure Verified Modules (AVM) — compose
  the live resource group out of AVM registry module calls (br/public:avm/res/... for Bicep,
  Azure/avm-res-*/azurerm for Terraform) rather than raw resource blocks. The Azure export
  APIs are used only as a config oracle to harvest live values, which are then wired into
  module inputs. Use when asked to "adopt as AVM", "verified modules", "AVM brownfield",
  "convert to AVM", "modularize existing Azure infra", or "reverse-engineer into AVM modules".
license: MIT
compatibility: >
  Requires az login authenticated. Bicep lane: bicep CLI (az bicep) for build/what-if; needs
  mcr.microsoft.com egress to restore modules. Terraform lane: terraform >= 1.5 and
  registry.terraform.io egress to init modules. ARM MCP server optional (governed control-plane
  upgrade); a direct authenticated ARM REST fallback (via `az rest`) works today with no MCP wired.
  Reads the live AVM module index (CSV) from raw.githubusercontent.com.
---

## Purpose

This skill handles the **adoption side** of AVM brownfield conversion for **both languages**:

- **What** to adopt (scope: resource / resource group / ARG query)
- **Which language** to target (Bicep or Terraform) — never defaulted silently
- **Which AVM modules** cover the in-scope types, and at **what coverage %** (via `avm-module-resolver`)
- **How** to harvest live config (control-plane export APIs used as a **config oracle**, dispatched
  through the export-dispatch seam)
- **Post-harvest triage** (types with no AVM module; secrets in the harvested config)

After discovery + coverage resolution + harvest, it **invokes the matching compose orchestrator**
(`bicep-avm-compose` or `terraform-avm-compose`) which turns the harvested config into pinned AVM
module calls, wires inputs, reconciles against AVM defaults, organizes, handles secrets, and gates
on validation. Those passes belong to the compose orchestrators and their sub-skills — not here.

## The core shift (vs. the raw-resource plugin, PR 1)

| | Raw-export plugin | This skill (AVM) |
|---|---|---|
| Output unit | raw `resource` blocks | **AVM module calls** (`br/public:avm/res/...`, `Azure/avm-res-*/azurerm`) |
| Export API role | **produces** the final code | **config oracle** — harvest live values only |
| Core engine | export-dispatch | **`avm-module-resolver`** (type → module + version + status + input schema) |
| Cleanup problem | prune computed props off the raw export | **map live config → module inputs** (the module owns the rest) |
| New intake signal | — | **coverage %** — how much of the scope has an AVM module, per language |
| Validation goal | faithful no-op what-if/plan | faithful **or** deliberate AVM-default posture uplift (reconciled) |

Because the AVM module is the unit, most of the raw export's decompile cruft and computed-property
noise never enters the tree — the module encapsulates it. The new problem is **coverage** (some
types have no usable module) and **reconciliation** (AVM secure-by-default inputs differ from the
live config).

## Separation of concerns

| Responsibility | This skill | compose orchestrator |
|---|:-:|:-:|
| Scoping (resource / RG / ARG query) | ✓ | |
| Language selection (bicep / terraform) | ✓ | |
| Type discovery (ARG inventory of in-scope types) | ✓ | |
| Coverage resolution (type → module/version/status) | ✓ (calls resolver) | |
| Harvest live config via oracle (export-dispatch) | ✓ | |
| Post-harvest triage (gaps, obvious secrets) | ✓ | |
| Module-call synthesis, input wiring, reconciliation | | ✓ |
| Organize, secrets, validate (syntax + fidelity/reconcile) | | ✓ |

## Workflow

### Phase 0: Intake & scoping

1. **Existing IaC?** Does the user already have AVM module calls and just want to adopt state /
   reconcile inputs against live? If yes and Terraform → harvest import blocks only (Phase 1A).
   Otherwise continue.
2. **Scope** — ask for exactly one:
   - single resource ID,
   - resource group name,
   - ARG (Azure Resource Graph) `where` predicate (e.g. `type =~ "microsoft.storage/storageaccounts"`).
3. **Language** — ask **bicep** or **terraform**. ⚠️ Do NOT default silently. Present neutrally, and
   note that **AVM coverage is asymmetric** (the Bicep index carries ~530 resource modules, the
   Terraform index ~150) — the actual coverage for *this* scope is computed in Phase 1 and fed back
   into this decision.
4. **Auth check** — run `az account show`. STOP with `az login` guidance if unauthenticated. Confirm
   the active subscription owns the scope; detect conflicting env vars and warn.
5. **Quality target** — "faithful adoption" (default: reproduce live config through module inputs,
   fidelity-gated) vs "posture uplift" (adopt AVM secure-by-default inputs where they differ, each
   diff logged as a deliberate decision in `reconciliation.json`).

> **Set expectations here, not at the gate.** A brownfield AVM adopt is override-heavy and
> **never reaches a true zero-diff on either language** — Terraform leaves a phantom unconditional
> `time_sleep` add, Bicep leaves permanent cosmetic `Modify` noise on every AVM-authored resource.
> The live-proven list of secure defaults that drift (storage `Standard_ZRS` *silently*,
> `requireInfrastructureEncryption`, blob/container soft-delete, LAW `forceCmkForQuery`, KV
> RBAC-shape inversion, subnet outbound/PE-policies, network default-deny) and the irreducible
> residual per lane are catalogued in **`reference/reconciliation-catalog.md`** — read it before
> promising fidelity.

Record the intake decisions to `<workdir>/.avm/intake.json` (verbatim language/mode quotes) so the
downstream validate gate can confirm scope selection (Gate C).

### Phase 1: Discover → resolve coverage → harvest

#### Phase 1.1 — Discover in-scope types (Azure Resource Graph)

Enumerate the distinct ARM types actually present in scope **before** any code is generated:

```
Resources
| where resourceGroup =~ "<rg>"           // or the user's ARG predicate / a single id filter
| summarize count() by type, apiVersion
```

This inventory (type + count) is the input to coverage resolution. See `reference/examples.md`.

#### Phase 1.2 — Resolve coverage (invoke `avm-module-resolver`)

Hand the type inventory + chosen language to **`avm-module-resolver`**. It joins each type to the
AVM index and writes `<workdir>/.avm/coverage.json`:

- `resolved[]` — type → `{ module, version, status }` (usable: Available/Orphaned)
- `gaps[]` — type → `{ status, fallback }` (Proposed/Deprecated/absent, per the chosen language)
- `coveragePct` — resolved ÷ total in-scope types

**Present coverage back to the user as part of intake.** If coverage is low for the chosen language
but high for the other (the Synapse-style asymmetry), surface that so they can revisit Phase 0.3 —
do not silently proceed to a mostly-fallback composition.

#### Phase 1.3 — Harvest live config (export API as a config oracle)

Harvest the concrete live values for the in-scope resources through the **export-dispatch seam**
(same abstraction as the raw plugin; here the output is consumed as **input values**, not final
code). Resolve in this **preference order** (first available wins):

1. **ARM MCP RP tool** — a first-class ARM MCP tool for the export/read action, if registered.
2. **ARM MCP generic POST-action** — `list_available_actions → generate_resource_action_body →
   submit_resource_action`, once that write path ships.
3. **Direct ARM REST via `az rest`** — the **works-today path**. `exportTemplate` (ARM JSON) or a
   per-resource `GET .../<id>?api-version=<v>` yields the live property bag. `az rest` auto-attaches
   the bearer token.

The harvested property bag per resource → `<workdir>/.avm/harvest/<name>.json`. This is the oracle
the compose lane reads to fill module inputs. Never hand-fabricate a value the oracle can supply.

#### Phase 1A: Terraform import-blocks-only path (adopt existing AVM code)

When the user already has AVM Terraform module calls and only wants to adopt state:
1. Harvest import blocks for the live resources (map each to the module's internal resource address).
2. Return import + `moved {}` blocks; do NOT generate new module calls — the user's code is source
   of truth.
3. If validation is requested, invoke `terraform-avm-validate` directly (the only legitimate entry
   into validate outside the compose orchestrator).

### Phase 2: Post-harvest triage

Light triage only — **not** composition. Two jobs:

1. **Gap confirmation** — for every `coverage.json` gap, confirm the fallback with the user
   (`raw-resource` inline, `child-of-parent` fold, or `defer`/exclude). Record the choice; the
   compose lane must not invent a module for a gap.
2. **Obvious-secret flagging** — mark harvested values that are plainly secret (connection strings,
   keys, `administratorLoginPassword`) so the compose lane's `-secrets` pass routes them to secure
   inputs / Key Vault references. Never write a harvested secret into a params/tfvars literal.

### Phase 3: Hand off to the matching compose orchestrator

```
language == "bicep"     → invoke bicep-avm-compose with:
        - .avm/coverage.json (resolved + gaps + versions)
        - .avm/harvest/*.json (live config oracle)
        - quality target (faithful | uplift)
language == "terraform" → invoke terraform-avm-compose with the same inputs.
```

### Phase 4: Adoption summary

```
## Adoption Summary
- Scope:     [resource / resource group / ARG query]
- Target:    [id / rg-name / query]
- Language:  Bicep | Terraform
- Dispatch:  ARM MCP RP tool | ARM MCP POST-action | direct ARM REST (az rest)

## Coverage
- N of M in-scope types resolved to AVM modules (X% coverage)
- Gaps: [type → fallback], ...

## Next step
- [bicep-avm-compose | terraform-avm-compose orchestrator invoked — composition in progress]
```

## Guardrails

| Rule | Enforcement |
|---|---|
| Always ask language (bicep/terraform) if not stated | Present choices; never silently default |
| Resolve coverage per the chosen language's index only | Never assume a Bicep module implies a TF one |
| Surface coverage % before composing | Low coverage is an intake decision, not a silent fallback |
| Export APIs are a **config oracle**, not the output | Harvested values feed module inputs only |
| Never execute `terraform apply` / `az deployment ... create` | Hard stop — read/harvest only |
| Never install tools silently | STOP with install instructions |
| One resource's harvest error never blocks others | Continue; surface in the summary |
| Never fabricate config values | Only values from the oracle or provider/ARM docs |
| Never write a harvested secret into a params/tfvars literal | Flag for the `-secrets` pass |
| Never invent an AVM module for a coverage gap | Gaps take a confirmed fallback |
| Prefer MCP dispatch, fall back to ARM REST — never hard-fail on unwired MCP | seam order (1)→(2)→(3) |

## Tools & endpoints used

| Mechanism | Phase | Purpose |
|---|---|---|
| Azure Resource Graph (`az graph query` / ARM REST) | 1.1 | Enumerate in-scope types |
| `avm-module-resolver` (reads AVM index CSVs) | 1.2 | Type → module/version/status; coverage.json |
| ARM MCP RP export/read tool (if present) | 1.3 | Preferred governed harvest dispatch |
| ARM MCP generic POST-action (if shipped) | 1.3 | Governed harvest dispatch |
| `az rest` → `exportTemplate` / per-resource GET | 1.3 | Live config harvest (POC fallback) |
| `az account show` | 0 | Auth / subscription check |

## References

- `reference/examples.md` — ARG type-inventory queries, `az rest` harvest, resolver hand-off,
  and the shape of `coverage.json` / harvest files.
- `reference/reconciliation-catalog.md` — **Round-1 live-proven** catalog of AVM secure-default
  drift (with per-language override inputs) + the irreducible residual thesis (neither lane reaches
  true zero-diff). Consume from the reconciliation passes and to set validate-gate expectations.
- Sibling `avm-module-resolver` — the type→module engine; owns `coverage.json`.
- Sibling `bicep-avm-compose` — gated Bicep AVM composition orchestrator.
- Sibling `terraform-avm-compose` — gated Terraform AVM composition orchestrator.
- `avm-module-resolver/reference/module-index.md` — the join table + status semantics.
- `avm-module-resolver/reference/version-resolution.md` — MCR / Registry version pinning.
