---
name: terraform-avm-compose
description: >
  Compose harvested Azure config into production-quality Terraform built from Azure Verified Modules
  (AVM) module calls. Thin orchestrator that invokes a fixed sequence of sub-skills
  (terraform-avm-map, terraform-avm-inputs, terraform-avm-organize, terraform-avm-secrets,
  terraform-avm-validate) and gates the final validate→plan loop on an on-disk checklist. Use when
  asked to "compose AVM terraform", "build terraform from AVM modules", "modularize into AVM", or
  when brownfield-avm-adopt hands off harvested config for the Terraform lane.
license: MIT
compatibility: >
  Requires terraform >= 1.5 (import blocks) and registry.terraform.io egress to source AVM modules.
  Reads coverage.json (from avm-module-resolver) and .avm/harvest/*.json (the config oracle). The
  plan fidelity gate uses `terraform plan` against a backend bound to the live estate via import blocks.
---

## Purpose

This is the **orchestrator** for Terraform AVM composition. It does not compose itself. Each pass is
a separately-invoked sub-skill that writes a JSON artifact describing what it did. The validate pass
refuses to run until every required artifact exists.

This mirrors the raw plugin's `terraform-cleanup` gating architecture (the crown jewel of the raw
plugin) so that raw-resource and AVM pipelines enforce the **same evidence-gated discipline** —
parity is enforced, not aspirational. It addresses the failure mode where a monolithic composer
silently skips the reconciliation ledger or the import wiring once `plan` happens to look clean.

## When to invoke

- `brownfield-avm-adopt` is handing off `coverage.json` + `.avm/harvest/*.json` for the Terraform lane.
- User has a coverage resolution and harvested config and wants AVM module Terraform built from it.

> Validate-only (run `terraform validate`/`plan` against existing AVM code without composing) is
> **not** an orchestrator entry point. Route those requests directly to `terraform-avm-validate`.

## Inputs

| Input | Source | Required |
|---|---|---|
| `.avm/coverage.json` (resolved modules + versions + gaps) | `avm-module-resolver` | YES |
| `.avm/harvest/*.json` (live config oracle) | `brownfield-avm-adopt` Phase 1.3 | YES |
| `.avm/intake.json` (language/mode/target quotes) | `brownfield-avm-adopt` Phase 0 | YES |
| Quality target (faithful \| uplift) | Intake | YES |
| Provider target (`azurerm`) + subscription | User or detected | YES for plan fidelity gate |

## Workflow

### Phase 1: Assessment

1. Read `coverage.json`; confirm ≥1 `resolved` module and that every `gap` has a confirmed
   `fallback`. Terraform AVM coverage (153 modules) is **narrower** than Bicep (531) — expect more
   gaps and surface the coverage % prominently. If a gap is unconfirmed, stop and ask.
2. Report the plan: N modules to compose, M gaps with fallbacks, coverage %.
3. Propose mode (**Full** default; **Partial** only if the user names passes to skip).
4. Ensure `<workdir>/.avm/intake.json` records mode + provider/subscription + quality target. If
   `mode != "full"`, intake **must** include `mode_selection_quote` or `terraform-avm-validate`
   Gate C fails the run.
5. Create `<workdir>/.avm/checklist.json` with one entry per scheduled pass, `status: "pending"`.

### Phase 2: Input-schema enrichment (recommended)

For every resolved module, fetch its **variable schema** and its **managed-resource addresses** so
input wiring and import blocks are deterministic:
- `terraform init` with the pinned module `source`/`version`, then read the module's `variables.tf`
  and enumerate the resource addresses it creates (`module.<name>.<type>.<name>`), or read them from
  the module `RepoURL`.
- Save to `<workdir>/.avm/schema/<module>.json`. This makes `terraform-avm-inputs` precise and lets
  `terraform-avm-map` emit correct `import` blocks. If unavailable, proceed degraded.

### Phase 3: Composition (invoke sub-skills in order)

| Order | Sub-skill | Artifact |
|------:|-----------|----------|
| 3.1 | `terraform-avm-map`     | `map.json` (module blocks + version pins + `import` blocks + gap fallbacks) |
| 3.2 | `terraform-avm-inputs`  | `inputs.json` + `reconciliation.json` (config → variables, AVM-default diffs) |
| 3.3 | `terraform-avm-organize`| `organize.json` (files split, may report `skipped`) |
| 3.4 | `terraform-avm-secrets` | `secrets.json` |

Do not proceed until the current pass reports `status: "complete"`. If a sub-skill reports
`incomplete` or fails, **stop** and surface it.

### Phase 4: Validate → Plan

Invoke `terraform-avm-validate`. Its hard precondition is **Gates A, B, C, D** (checklist read;
grep/file cross-checks; mode audit; **reconciliation-ledger completeness**). Gate commands are tool
calls run in the same turn as the validate result.

### Phase 5: Summary & Handoff

```
## terraform-avm-compose Summary
- Modules composed: <N> (AVM resolved)
- Gaps handled: <M> [raw-resource / defer]
- Import blocks emitted: <N>
- Inputs wired from oracle: <N>
- Reconciled AVM-default diffs: <N> adopt / <N> pin
- Sensitive inputs identified: <N>
- Plan status: [zero-diff / <N> intentional / unresolved]

## Action required
- [ ] Fill secrets.auto.tfvars with real values
- [ ] Review reconciliation ledger (adopt vs pin decisions)
- [ ] Run `terraform apply` (user action — never automated here)

## Artifacts
- <workdir>/.avm/checklist.json, coverage.json, reconciliation.json, *.json
```

Do not claim "complete" unless every required `checklist.json` entry is `complete` (or `skipped`
with a `reason`).

## Checklist schema

`<workdir>/.avm/checklist.json`:

```json
{
  "schema_version": 1,
  "mode": "full",
  "language": "terraform",
  "provider": "azurerm",
  "quality_target": "faithful",
  "target": { "subscription_id": "…" },
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
| Never execute `terraform apply` | Hard stop — plan is read-only |
| Never proceed past a plan with destroys | Surface, confirm with user first |
| Never claim "complete" with a pending pass | `terraform-avm-validate` Gate A |
| Gate-command output must appear in the same turn as the success claim | Gates A/B/C/D |
| Every non-empty plan line maps to a `reconciliation.json` entry marked `adopt` | Gate D |
| Every module-managed live resource has an `import` block | `terraform-avm-map` / Gate B |
| Never invent a module for a coverage gap | `terraform-avm-map` |
| Max 10 validate→plan iterations | Circuit breaker (in `terraform-avm-validate`) |
| Never hardcode subscription IDs / secrets | `terraform-avm-inputs` + `terraform-avm-secrets` |
| Sub-skill ordering is fixed | Do not reorder |
| Non-full modes require `mode_selection_quote` in intake.json | `terraform-avm-validate` Gate C |
| Always pin module versions (never float) | `terraform-avm-map` (from coverage.json) |

## Mode behaviors

- **Full compose** (default): 3.1 → 3.4, then 4. Gate A enforces every required pass reaches
  `status ∈ {"complete","skipped"}` with a `reason` on every `skipped`.
- **Partial**: user names passes to skip; orchestrator records the verbatim utterance in
  `intake.mode_selection_quote`; opted-out passes → `skipped` with that quote. Without it Gate C
  rejects the run.
- **Validate only**: not an orchestrator mode. Invoke `terraform-avm-validate` directly.

## References

- Sibling `avm-module-resolver` — type→module engine; owns `coverage.json`.
- Sibling `terraform-avm-inputs` — config→variable mapping + AVM-default reconciliation rules (A1.x–A5.x).
- Sibling `terraform-avm-validate` — validate (syntax) + plan (fidelity/reconcile) gate.
- Counterpart `bicep-avm-compose` — the Bicep lane this mirrors for parity.
