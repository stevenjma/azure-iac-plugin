---
name: bicep-avm-compose
description: >
  Compose harvested Azure config into production-quality Bicep built from Azure Verified Modules
  (AVM) module calls. Thin orchestrator that invokes a fixed sequence of sub-skills
  (bicep-avm-map, bicep-avm-inputs, bicep-avm-organize, bicep-avm-secrets, bicep-avm-validate)
  and gates the final build→what-if loop on an on-disk checklist. Use when asked to "compose
  AVM bicep", "build bicep from AVM modules", "modularize into AVM", or when brownfield-avm-adopt
  hands off harvested config.
license: MIT
compatibility: >
  Requires the bicep CLI (`az bicep`) and mcr.microsoft.com egress to restore AVM modules. Reads
  coverage.json (from avm-module-resolver) and .avm/harvest/*.json (the config oracle). The
  what-if fidelity gate uses ARM MCP whatif_deployment when wired, else `az deployment group what-if`.
---

## Purpose

This is the **orchestrator** for Bicep AVM composition. It does not compose itself. Each pass is a
separately-invoked sub-skill that writes a JSON artifact describing what it did. The validate pass
refuses to run until every required artifact exists.

This mirrors the raw plugin's `bicep-cleanup` gating architecture so that raw-resource and AVM
pipelines enforce the **same evidence-gated discipline** — parity is enforced, not aspirational.
It directly addresses the failure mode where a monolithic composer silently skips the reconciliation
ledger once `what-if` happens to look clean.

## When to invoke

- `brownfield-avm-adopt` is handing off `coverage.json` + `.avm/harvest/*.json` for the Bicep lane.
- User has a coverage resolution and harvested config and wants AVM module code built from it.

> Validate-only (run `bicep build`/`what-if` against existing AVM code without composing) is **not**
> an orchestrator entry point. Route those requests directly to `bicep-avm-validate`.

## Inputs

| Input | Source | Required |
|---|---|---|
| `.avm/coverage.json` (resolved modules + versions + gaps) | `avm-module-resolver` | YES |
| `.avm/harvest/*.json` (live config oracle) | `brownfield-avm-adopt` Phase 1.3 | YES |
| `.avm/intake.json` (language/mode/target quotes) | `brownfield-avm-adopt` Phase 0 | YES |
| Quality target (faithful \| uplift) | Intake | YES |
| Target resource group + subscription | User or detected | YES for what-if fidelity gate |

## Workflow

### Phase 1: Assessment

1. Read `coverage.json`; confirm ≥1 `resolved` module and that every `gap` has a confirmed
   `fallback` (from `brownfield-avm-adopt` Phase 2). If a gap is unconfirmed, stop and ask.
2. Report the plan: N modules to compose, M gaps with their fallbacks, coverage %.
3. Propose mode:
   - **Full compose** (all passes) — default. Use unless the user explicitly opts out.
   - **Partial** — only if the user explicitly names which passes to skip.
4. Ensure `<workdir>/.avm/intake.json` records mode + target RG/subscription + quality target. If
   `mode != "full"`, intake **must** include `mode_selection_quote` (verbatim user request) or
   `bicep-avm-validate` Gate C fails the run. Do not infer consent.
5. Create `<workdir>/.avm/checklist.json` with one entry per scheduled pass, `status: "pending"`.

### Phase 2: Input-schema enrichment (recommended)

For every resolved module, fetch its **input schema** so wiring is deterministic rather than
guess-and-check:
- Bicep: `az bicep restore` the pinned `br/public:...` source, then read the module's `metadata`
  and parameter declarations; or read the module `main.bicep` params from `RepoURL`.
- Build a per-module input map (required params, allowed enums, secure params, defaults) →
  `<workdir>/.avm/schema/<module>.json`. This makes `bicep-avm-inputs` and the reconciliation
  ledger precise. If unavailable, proceed degraded (expect more what-if iterations).
- Resolve and fetch each distinct module once. Prefer the single `main.bicep` interface file over a
  repository scan, and reuse the cached schema in every downstream pass. If supporting AVM guidance
  is required, use `https://aka.ms/avm/llms` as the table of contents and open only the relevant
  source document.

### Phase 3: Composition (invoke sub-skills in order)

Invoke each sub-skill explicitly. Each writes its own `<pass>.json` and updates `checklist.json`.
Do not proceed until the current pass reports `status: "complete"`.

| Order | Sub-skill | Artifact |
|------:|-----------|----------|
| 3.1 | `bicep-avm-map`     | `map.json` (type → module block skeleton + gap fallbacks) |
| 3.2 | `bicep-avm-inputs`  | `inputs.json` + `reconciliation.json` (config → params, AVM-default diffs) |
| 3.3 | `bicep-avm-organize`| `organize.json` (may report `skipped` if a single file is appropriate) |
| 3.4 | `bicep-avm-secrets` | `secrets.json` |

If a sub-skill reports `status: "incomplete"` or fails, **stop** and surface the failure.

### Phase 4: Validate → What-if

Invoke `bicep-avm-validate`. Its hard precondition is **Gates A, B, C, D** (checklist read;
grep/file cross-checks; mode audit; **reconciliation-ledger completeness**). Gate commands are tool
calls run in the same turn as the validate result — their output is the evidence.

> **Field-proven residual (Round-1 live evidence).** A brownfield AVM adopt does **not** reach
> all-`NoChange`. Every AVM-authored resource stays **`Modify`** — AVM writes explicit property
> values the ARM RP omits on GET (effective `forceCmkForQuery`, empty `customDomain` object,
> `largeFileSharesState: 'Disabled'`, explicit-false blob retention, read-only container
> encryption-scope fields the RP deletes), so property-level what-if never collapses to `NoChange`
> for them. **Only pure-ARM resources** (e.g. vnet/subnet) reach `NoChange` — the *inverse* of the
> Terraform lane's phantom-`add` asymmetry. The gate asserts **no `Create`/`Delete` of a real
> resource** and that every `Modify` is either a chosen override or a documented AVM-authoring
> artifact — not empty what-if. Closing the *real* secure-default drift (LAW `forceCmkForQuery`,
> storage `requireInfrastructureEncryption`, blob + container soft-delete) took **4 explicit param
> overrides**. See `../brownfield-avm-adopt/reference/reconciliation-catalog.md`.

### Phase 5: Summary & Handoff

Read every `<pass>.json` and produce:

```
## bicep-avm-compose Summary
- Modules composed: <N> (AVM resolved)
- Gaps handled: <M> [raw-resource / child-of-parent / defer]
- Inputs wired from oracle: <N>
- Reconciled AVM-default diffs: <N> adopt / <N> pin
- Secure inputs identified: <N>
- What-if status: [no changes / <N> intentional / unresolved]

## Action required
- [ ] Supply secure parameter values (Key Vault refs or --parameters at deploy)
- [ ] Review reconciliation ledger (adopt vs pin decisions)
- [ ] Run `az deployment group create` (user action — never automated here)

## Artifacts
- <workdir>/.avm/checklist.json
- <workdir>/.avm/coverage.json, reconciliation.json, *.json
```

Do not claim "complete" unless every required entry in `checklist.json` has `status: "complete"`
(or `"skipped"` with a `reason`).

## Checklist schema

`<workdir>/.avm/checklist.json`:

```json
{
  "schema_version": 1,
  "mode": "full",
  "language": "bicep",
  "quality_target": "faithful",
  "target": { "subscription_id": "…", "resource_group": "rg1" },
  "passes": [
    { "id": "3.1-map",      "status": "complete", "artifact": "map.json" },
    { "id": "3.2-inputs",   "status": "complete", "artifact": "inputs.json" },
    { "id": "3.3-organize", "status": "skipped", "reason": "single logical file; split not warranted", "artifact": "organize.json" },
    { "id": "3.4-secrets",  "status": "complete", "artifact": "secrets.json" },
    { "id": "4-validate",   "status": "complete", "artifact": "validate.json" }
  ]
}
```

## Guardrails

| Rule | Enforcement |
|---|---|
| Never execute `az deployment group create` (apply) | Hard stop — what-if is read-only |
| Never proceed past a what-if with deletes | Surface, confirm with user first |
| Never claim "complete" with a pending pass | `bicep-avm-validate` Gate A |
| Gate-command output must appear in the same turn as the success claim | Gates A/B/C/D |
| Every non-empty what-if line maps to a `reconciliation.json` entry marked `adopt` | Gate D |
| Never invent a module for a coverage gap | `bicep-avm-map` (gaps take confirmed fallbacks) |
| Max 10 build→what-if iterations | Circuit breaker (in `bicep-avm-validate`) |
| Never hardcode `subscriptionId` / secrets | `bicep-avm-inputs` + `bicep-avm-secrets` |
| Sub-skill ordering is fixed | Do not reorder; each pass assumes the previous ran |
| Non-full modes require `mode_selection_quote` in intake.json | `bicep-avm-validate` Gate C |
| Always pin module versions (never float) | `bicep-avm-map` (from coverage.json) |

## Mode behaviors

- **Full compose** (default): run 3.1 → 3.4, then 4. Gate A enforces every required pass reaches
  `status ∈ {"complete","skipped"}` and every `skipped` has a non-empty `reason`.
- **Partial**: user explicitly names which sub-skills to skip; orchestrator records the verbatim
  utterance in `intake.mode_selection_quote`; checklist marks each opted-out pass
  `status: "skipped", reason: "user opted out: <quote>"`. Without the quote, Gate C rejects the run.
- **Validate only**: not an orchestrator mode. Invoke `bicep-avm-validate` directly.

## References

- Sibling `avm-module-resolver` — type→module engine; owns `coverage.json`.
- Sibling `bicep-avm-inputs` — config→input mapping + AVM-default reconciliation rules (A1.x–A5.x).
- Sibling `bicep-avm-validate` — build (syntax) + what-if (fidelity/reconcile) gate.
- Counterpart `terraform-avm-compose` — the Terraform lane this mirrors for parity.
