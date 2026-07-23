---
name: bicep-cleanup
description: >
  Use this skill when the user asks to clean up, refine, fix, or validate raw, exported, or
  decompiled Bicep. Orchestrates parameterization, pruning, organization, secret handling,
  build/lint, and live what-if through an evidence-gated pipeline.
license: MIT
compatibility: >
  Requires the bicep CLI (`az bicep`). A resource-type schema source (ARM MCP resource-type
  schema tools, or `az provider show`) is recommended for doc-fetch enrichment; works without it
  (slower convergence). The what-if fidelity gate uses ARM MCP `whatif_deployment` when wired,
  else falls back to `az deployment group what-if`.
---

## Purpose

This is the **orchestrator** for bicep-cleanup work. It does not perform refinements itself.
Each refinement pass is a separately-invoked sub-skill that writes a JSON artifact describing
what it did. The validate pass refuses to run until every required artifact exists.

This mirrors the `terraform-cleanup` gating architecture (the crown jewel of this plugin) so that
Bicep and Terraform enforce the **same evidence-gated discipline** — parity is enforced, not
aspirational. It directly addresses the failure mode where a monolithic cleanup skill silently
skips passes once `what-if` happens to look clean.

## When to invoke

- User has decompiled Bicep (from `brownfield-iac-export`) that "works but is ugly".
- User ran `az bicep decompile` themselves and wants cleanup.
- The `brownfield-iac-export` skill is handing off raw decompiled `main.bicep`.

> Validate-only (run `bicep build`/`what-if` against existing code without refinement) is **not**
> an orchestrator entry point. Route those requests directly to the `bicep-validate` sub-skill.

## Inputs

| Input | Source | Required |
|---|---|---|
| `main.bicep` to refine | Directory path | YES |
| `template.json` (source ARM JSON) | From export | Recommended (decompile provenance) |
| Decompile warnings | From export Phase 2 | Recommended |
| Target resource group + subscription | User or detected | YES for what-if fidelity gate |
| Live infra access | For build→what-if loop | Recommended |

## Workflow

### Phase 1: Assessment

1. Scan `main.bicep`; count resources, detect raw-decompile signatures: generated
   `param_*`/`var_*` names, literal subscription IDs / resource names, `apiVersion` sprawl,
   redundant `dependsOn`, computed/readonly properties copied verbatim, no `@description`,
   flat single-file structure.
2. Report findings; propose mode:
   - **Full bicep-cleanup** (all passes) — default. Use unless the user explicitly opts out.
   - **Partial** — only if the user explicitly names which passes to skip.
3. Write `<workdir>/.cleanup/intake.json` with mode, target RG/subscription, and hints. If
   `mode != "full"`, intake **must** include `mode_selection_quote` (verbatim user request that
   selected the non-full mode) or `bicep-validate` Gate C fails the run. Do not infer consent.
4. Create `<workdir>/.cleanup/checklist.json` with one entry per scheduled pass, each
   initialized to `status: "pending"`.

### Phase 2: Doc Enrichment (optional, recommended)

If a resource-type schema source is available (ARM MCP `get_resource_type_schema`, or
`az provider show`), fetch schemas for every resource type in scope and build a constraint map
(which properties are readOnly/computed, required, allowed enum values). Save to
`<workdir>/.cleanup/constraint-map.json`. This makes `bicep-prune` and `bicep-validate`
deterministic rather than guess-and-check. If unavailable, ask the user to wire ARM MCP or
proceed in degraded mode (expect more what-if iterations).

### Phase 3: Refinement (invoke sub-skills in order)

Invoke each sub-skill explicitly. Each writes its own `<pass>.json` and updates `checklist.json`.
Do not proceed to the next pass until the current reports `status: "complete"`.

| Order | Sub-skill | Artifact |
|------:|-----------|----------|
| 3.1 | `bicep-parameterize` | `parameterize.json` |
| 3.2 | `bicep-prune`        | `prune.json` |
| 3.3 | `bicep-organize`     | `organize.json` (may report `skipped` if single-module is appropriate) |
| 3.4 | `bicep-secrets`      | `secrets.json` |

If a sub-skill reports `status: "incomplete"` or fails, **stop** and surface the failure.

### Phase 4: Validate → What-if

Invoke `bicep-validate`. Its hard precondition is **Gates A, B, C** (a checklist read plus a
sequence of grep/file-existence checks against the working tree). The gate commands are tool
calls run in the same turn as the validate result — their output is the evidence.

> **The what-if floor never reaches literal zero — and that's expected.** `exportTemplate`→
> decompile baselines retain an **irreducible cosmetic floor** of `Modify`s (live example: a
> container `immutableStorageWithVersioning` default; an empty `queueServices` `logging` body)
> plus `[NoEffect]` deltas that are ARM what-if artifacts, not real changes. Declare
> "no changes" once only this documented floor remains. Record it verbatim: when this baseline
> is reused as a **drift oracle**, subtract the floor and ignore `[NoEffect]` before calling any
> later delta real drift — otherwise cosmetic residue reads as a false positive.

### Phase 5: Summary & Handoff

Read every `<pass>.json` and produce:

```
## bicep-cleanup Summary
- Files refined: <N>
- Parameters extracted: <N> (incl. location, resource names)
- Properties pruned (readonly/computed/redundant): <N>
- Modules organized into: [list]
- Secure params identified: <N>
- What-if status: [no changes / <N> intentional / unresolved]

## Action required
- [ ] Supply secure parameter values (Key Vault refs or --parameters at deploy)
- [ ] Review intentional what-if deltas
- [ ] Run `az deployment group create` (user action — never automated here)

## Artifacts
- <workdir>/.cleanup/checklist.json
- <workdir>/.cleanup/*.json
```

Do not claim "complete" unless every required entry in `checklist.json` has `status: "complete"`
(or `"skipped"` with a `reason`).

## Checklist schema

`<workdir>/.cleanup/checklist.json`:

```json
{
  "schema_version": 1,
  "mode": "full",
  "language": "bicep",
  "target": { "subscription_id": "…", "resource_group": "rg1" },
  "passes": [
    { "id": "3.1-parameterize", "status": "complete", "artifact": "parameterize.json" },
    { "id": "3.2-prune",        "status": "complete", "artifact": "prune.json" },
    { "id": "3.3-organize",     "status": "skipped", "reason": "single logical module; split not warranted", "artifact": "organize.json" },
    { "id": "3.4-secrets",      "status": "complete", "artifact": "secrets.json" },
    { "id": "4-validate",       "status": "complete", "artifact": "validate.json" }
  ]
}
```

## Guardrails

| Rule | Enforcement |
|---|---|
| Never execute `az deployment group create` (apply) | Hard stop — what-if is read-only |
| Never proceed past a what-if with deletes | Surface, confirm with user first |
| Never claim "complete" with a pending pass | `bicep-validate` Gate A |
| Gate-command output must appear in the same turn as the success claim | `bicep-validate` Gates A/B/C |
| Max 10 build→what-if iterations | Circuit breaker (in `bicep-validate`) |
| Never hardcode `subscriptionId` / secrets | `bicep-parameterize` + `bicep-secrets` |
| Sub-skill ordering is fixed | Do not reorder; each pass assumes the previous ran |
| Non-full modes require `mode_selection_quote` in intake.json | `bicep-validate` Gate C |

## Mode behaviors

- **Full bicep-cleanup** (default): run 3.1 → 3.4, then 4. `bicep-validate` Gate A enforces every
  required pass reaches `status ∈ {"complete","skipped"}` and every `skipped` has a non-empty `reason`.
- **Partial**: user explicitly names which sub-skills to skip; orchestrator records the verbatim
  utterance in `intake.mode_selection_quote`; checklist marks each opted-out pass
  `status: "skipped", reason: "user opted out: <quote>"`. Without the quote, Gate C rejects the run.
- **Validate only**: not an orchestrator mode. Invoke `bicep-validate` directly.

## References

- Sibling `azure-to-bicep-translation` — decompile→what-if drift fix rules (Rule B1.x – B5.x).
- Sibling `bicep-validate` — build (syntax) + what-if (fidelity) gate.
- Counterpart `terraform-cleanup` — the Terraform pipeline this mirrors for parity.
