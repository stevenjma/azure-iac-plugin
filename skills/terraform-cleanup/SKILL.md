---
name: terraform-cleanup
description: >
  Refine raw or exported Terraform code into production-quality HCL. Thin orchestrator
  that invokes a sequence of sub-skills (cleanup-references, cleanup-variables,
  cleanup-prune, cleanup-consolidate, cleanup-organize, cleanup-secrets, cleanup-validate)
  and gates the final validate→plan loop on an on-disk checklist. Use when asked to
  "clean up Terraform", "refine Terraform code", "fix my terraform", or "validate and
  fix" Terraform code.
license: MIT
compatibility: >
  Requires terraform >= 1.5. A provider-schema doc source (Terraform Registry /
  `terraform providers schema -json`, or ARM MCP resource-type schema tools) is recommended
  for doc-fetch enrichment; works without it (slower convergence).
---

## Purpose

This is the **orchestrator** for terraform-cleanup work. It does not perform refinements itself.
Each refinement pass is a separately-invoked sub-skill that writes a JSON artifact
describing what it did. The validate pass refuses to run until every required artifact
exists.

This design directly addresses a failure mode where a single monolithic terraform-cleanup skill
would silently skip passes once `terraform plan` happened to look clean.

## When to invoke

- User has existing Terraform code that "works but is ugly".
- User ran `terraform import` or aztfexport themselves and wants terraform-cleanup.
- The `brownfield-terraform-export` skill is handing off raw exported code.

> Validate-only (run `terraform validate`/`plan` against existing code without
> refinement) is **not** an orchestrator entry point. Route those requests
> directly to the `cleanup-validate` sub-skill — see the note in Workflow below.

## Inputs

| Input | Source | Required |
|---|---|---|
| `.tf` files to refine | Directory path | YES |
| Provider target (`azurerm` / `azapi`) | User or detected | YES (ask if unclear) |
| Terraform version | `terraform version` | Auto-detect |
| Import blocks (if brownfield) | `import.tf` | Optional |
| Live infra access | For validate→plan loop | Recommended |

## Workflow

### Phase 1: Assessment

1. Scan provided `.tf` files; count resources, detect provider(s), find signs of raw
   export (`res-N` names, literal IDs, `null # sensitive`, flat structure).
2. Report findings to the user, propose mode:
   - **Full terraform-cleanup** (all passes) — default. Use unless the user explicitly opts out.
   - **Partial** — only allowed if the user explicitly names which passes to skip.
3. Write `<workdir>/.cleanup/intake.json` with the chosen mode, provider, and hints.
   If `mode != "full"`, the intake **must** include `mode_selection_quote` — the
   verbatim user request that selected the non-full mode. Without it
   `cleanup-validate` Gate C will fail the run. Do not infer consent; quote the user.
4. Create `<workdir>/.cleanup/checklist.json` with one entry per scheduled pass,
   each initialized to `status: "pending"`.

> **Validate-only is not an orchestrator mode.** If the user only wants to run
> `terraform validate` and `plan` against existing code without refinement, invoke
> the `cleanup-validate` sub-skill directly — do not enter the orchestrator. The
> orchestrator's success summary always implies refinement happened; degrading it
> to validate-only would recreate the original failure mode.

### Phase 2: Doc Enrichment (optional, recommended)

If a provider-schema doc source is available (Terraform Registry / `terraform providers
schema -json`, or ARM MCP resource-type schema tools), fetch provider docs for every
resource type in scope and build the constraint map (see `reference/constraint-map.md`).
Save to `<workdir>/.cleanup/constraint-map.json`.

If no doc source is available, ask the user:
1. Install MCP and restart (recommended) — see plugin `.mcp.json`.
2. Skip enrichment — proceed in degraded mode, expect more plan iterations.

### Phase 3: Refinement (invoke sub-skills in order)

Invoke each sub-skill explicitly. Each sub-skill writes its own `<pass>.json`
artifact and updates `checklist.json`. Do not proceed to the next pass until the
current one reports `status: "complete"`.

| Order | Sub-skill | Artifact |
|------:|-----------|----------|
| 3.1 | `cleanup-references`  | `references.json` |
| 3.2 | `cleanup-variables`   | `variables.json` |
| 3.3 | `cleanup-prune`       | `prune.json` |
| 3.3.5 | `cleanup-consolidate` | `consolidate.json` (may report `skipped` if no group qualifies) |
| 3.4 | `cleanup-organize`    | `organize.json` |
| 3.5 | `cleanup-secrets`     | `secrets.json` |

If a sub-skill reports `status: "incomplete"` or fails, **stop** and surface the
failure. Do not skip ahead.

### Phase 4: Validate → Plan

Invoke `cleanup-validate`. Its hard precondition is **Gates A, B, C** (a checklist
read plus a sequence of grep/file-existence commands against the working tree).
The gate commands are tool calls run in the same turn as the validate result —
their output is the evidence. An agent cannot claim the gate passed without the
output in the transcript.

> **Baseline doubles as a drift oracle.** When Plan status reaches **zero-diff**
> ("No changes"), that state is a *true* zero-diff baseline: re-run `terraform plan`
> against the live estate later and **every** reported change is real out-of-band
> drift — nothing to subtract. This is TF's fidelity advantage over the Bicep lane
> (which retains an irreducible cosmetic what-if floor). Record the zero-diff result
> as the reference floor for future drift reviews.

### Phase 5: Summary & Handoff

Read every `<pass>.json` and produce:

```
## terraform-cleanup Summary
- Files refined: <N>
- References injected: <N>
- Variables extracted: <N>
- Attributes pruned: <N>
- Resource groups consolidated via for_each: <N> (members: <M> → <K>)
- Files reorganized into: [list]
- Secrets identified: <N>
- Plan status: [zero-diff / <N> intentional / unresolved]

## Action required
- [ ] Fill secrets.auto.tfvars with real values
- [ ] Review intentional changes
- [ ] Run `terraform apply`

## Artifacts
- <workdir>/.cleanup/checklist.json
- <workdir>/.cleanup/*.json
```

Do not claim "complete" unless every required entry in `checklist.json` has
`status: "complete"` (or `"skipped"` with a `reason`).

## Checklist schema

`<workdir>/.cleanup/checklist.json`:

```json
{
  "schema_version": 1,
  "mode": "full",
  "provider": "azurerm",
  "passes": [
    { "id": "3.1-references",  "status": "complete", "artifact": "references.json" },
    { "id": "3.2-variables",   "status": "complete", "artifact": "variables.json" },
    { "id": "3.3-prune",       "status": "complete", "artifact": "prune.json" },
    { "id": "3.3.5-consolidate","status": "skipped", "reason": "no group ≥3 with ≥80% shared args", "artifact": "consolidate.json" },
    { "id": "3.4-organize",    "status": "complete", "artifact": "organize.json" },
    { "id": "3.5-secrets",     "status": "complete", "artifact": "secrets.json" },
    { "id": "4-validate",      "status": "complete", "artifact": "validate.json" }
  ]
}
```

## Guardrails

| Rule | Enforcement |
|---|---|
| Never execute `terraform apply` | Hard stop |
| Never proceed past a plan with destroys | Surface, confirm with user first |
| Never claim "complete" with pending pass | `cleanup-validate` Gate A |
| Gate-command output must appear in the same turn as the success claim | `cleanup-validate` Gates A/B/C |
| Max 10 validate→plan iterations | Circuit breaker (in `cleanup-validate`) |
| Respect provider preference for doc-fetch | azurerm code → read azurerm schema only; azapi code → read azapi schema only |
| Sub-skill ordering is fixed | Do not reorder; each pass assumes the previous ran |
| Non-full modes require `mode_selection_quote` in intake.json | `cleanup-validate` Gate C |

## Mode behaviors

- **Full terraform-cleanup** (default): run 3.1 → 3.5, then 4. `cleanup-validate` Gate A
  enforces every required pass reaches `status ∈ {"complete", "skipped"}` and
  every `skipped` entry has a non-empty `reason`.
- **Partial**: user explicitly names which sub-skills to skip. The orchestrator
  records the verbatim user utterance in `intake.mode_selection_quote`. The
  checklist marks each opted-out pass `status: "skipped", reason: "user opted out: <quote>"`.
  Without `mode_selection_quote`, `cleanup-validate` Gate C rejects the run.
- **Validate only**: not an orchestrator mode. Invoke `cleanup-validate` directly.

## References

- `reference/patterns.md` — patterns from live brownfield conversions.
- `reference/constraint-map.md` — schema for the Phase 2 constraint map.
- `reference/secrets-warning.md` — mandatory user warning template.
- Sibling skill `azure-to-terraform-translation` — drift fix rules (Rule 1.x – 9.x).
