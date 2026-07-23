---
name: bicep-validate
description: >
  Use this skill when the user asks to validate or dry-run Bicep against live Azure, or as the final
  bicep-cleanup gate. Build and lint the template, then run ARM what-if for at most 10 iterations
  until only documented, intentional differences remain. Always require the checklist and upstream
  evidence artifacts, including for validate-only use.
license: MIT
---

## Goal

Confirm the refined Bicep (a) compiles and lints clean (**syntax gate**), and (b) produces a
**what-if with no changes** — or only explicitly accepted intentional drift — against the live
resource group (**fidelity/gap gate**). A near-empty what-if means the export + cleanup faithfully
reproduces the source. This is the Bicep counterpart of `cleanup-validate`'s `terraform validate` +
`terraform plan`, and the primary Bicep↔Terraform parity signal (the "gap score").

## Hard precondition (do not skip)

Before running `az bicep build`, execute the gate commands below **in this turn** (the tool-call
output is the evidence; the agent cannot claim the gate passed without the matching output in the
transcript).

### Gate A: Checklist completeness

Read `<workdir>/.cleanup/checklist.json`. Refuse to proceed unless every required upstream pass has
`status ∈ {"complete", "skipped"}` AND every `skipped` entry has a non-empty `reason`:

```
required_upstream = [
  "3.1-parameterize", "3.2-prune", "3.3-organize", "3.4-secrets",
]
```

### Gate B: Working-tree cross-checks

Run each check using your built-in **grep tool** (not a shell command, so it works on Windows,
macOS, and Linux). For path-listing checks, use the **view** or **glob** tool. Capture the tool
output in the same turn as the validate result.

| Check | Tool invocation | Expected |
|---|---|---|
| No literal subscription IDs | grep pattern `/subscriptions/[0-9a-fA-F-]{36}` against `<workdir>/**/*.bicep` | 0 unjustified hits (each remaining hit must appear in `parameterize.json` `literal_ids_remaining_locations`) |
| Mandatory params present | grep pattern `^param +(location\|tags)\b` against `<workdir>/main.bicep` | ≥1 per name (or each absentee justified via an ARM function in `parameterize.json`) |
| No bare subscription GUID in resource bodies | grep pattern `'[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}'` against `<workdir>/**/*.bicep` excluding param defaults | 0 hits (or justified in `parameterize.json`) |
| Secrets are @secure(), no literals | grep pattern `@secure\(\)` count ≥ `secrets.json.secure_params_declared`; and grep for common secret literals (`password\s*[:=]\s*'`, `AccountKey=`, `SharedAccessKey`) | secure count matches; 0 literal-secret hits |
| No leftover generated symbols | grep pattern `\b(param_\|var_)[A-Za-z0-9]` against `<workdir>/**/*.bicep` | 0 hits (or listed in `prune.json` `uncertain_kept`) |
| Compiles | run `az bicep build --file <workdir>/main.bicep --stdout` | exit 0 |

### Gate C: Mode-selection audit (non-`full` modes only)

If `checklist.json` `mode != "full"`, read `<workdir>/.cleanup/intake.json` and confirm
`mode_selection_quote` is present and non-empty (the verbatim user utterance that selected the
non-full mode). Refuse to proceed otherwise — do not infer consent.

These checks are the gate. Do not summarize "all gates pass" without each command's output visible
in the same turn.

## Procedure

1. Run **Gates A, B, C** above. If any fails, stop.
2. **Syntax gate** — `az bicep build --file main.bicep` (compile) and `az bicep lint --file
   main.bicep` (lint). If either fails, categorize:
   - Type/schema error → invoke `azure-to-bicep-translation` for the matching rule, or fetch the
     resource-type schema (ARM MCP `get_resource_type_schema` / `az provider show`) and fix.
   - Symbol/reference error → return to `bicep-parameterize` or `bicep-organize`.
3. **Fidelity gate** — run what-if against the live RG:
   - **Preferred:** ARM MCP `whatif_deployment` (governed, caller RBAC) — pass the compiled
     template + parameters + target resource group.
   - **Fallback (works today):** `az deployment group what-if --resource-group <rg> --template-file
     main.bicep --parameters @secrets.parameters.example.json` (with placeholder secure values).
   - Use whichever is wired; both feed the same categorization below. Record which was used.
4. Categorize the what-if result:
   - `No changes` (all resources `NoChange`/`Ignore`) → **success**.
   - Only intentional drift (secure-param placeholders forcing a diff, provider-materialized
     defaults) → **success with notes**.
   - Unexpected `Modify` → invoke `azure-to-bicep-translation` for the matching rule; if it stems
     from a copied readOnly property, return to `bicep-prune`.
   - **Any `Delete`** → STOP, do not iterate. Surface to user.
5. Loop until success or 10 iterations.
6. Before marking the pass complete, re-run Gate B once more and include its output in the final
   summary.

## Drift categories (auto-fixable)

| Category | Example | Fix |
|---|---|---|
| ReadOnly copied into body | `provisioningState`, `id` present | Remove (`bicep-prune`) — Rule B2.x |
| Default materialization | `minimumTlsVersion` unset → platform default | Set explicitly — Rule B1.x |
| ID/case format mismatch | resourceId casing differs from live | Rebuild via `resourceId()`/symbolic ref — Rule B3.x |
| Secure placeholder diff | `@secure()` param forces `Modify` on a key | Accept as intentional; note it |
| apiVersion drift | stale version reports property delta | Normalize apiVersion (`bicep-prune`) — Rule B2.x |

## Acceptance Criteria (mandatory)

Write `<workdir>/.cleanup/validate.json`:

```json
{
  "pass": "4-validate",
  "status": "complete",
  "bicep_build": "pass",
  "bicep_lint": "pass",
  "whatif_engine": "arm-mcp:whatif_deployment",
  "iterations": 2,
  "final_whatif": { "create": 0, "modify": 1, "delete": 0, "nochange": 12 },
  "intentional_changes": [
    { "resource": "sqlServer", "field": "administratorLoginPassword", "reason": "@secure() placeholder forces modify; expected" }
  ],
  "gate_b_output_in_turn": true
}
```

The pass is **not complete** unless:
- Gates A, B, C output appears in the same turn as the success summary.
- `bicep_build == "pass"` and `bicep_lint == "pass"`.
- `final_whatif.delete == 0`.
- Every `modify` is in `intentional_changes` with a `reason`.

## Guardrails

- Never run `az deployment group create` (apply). What-if is read-only.
- Never proceed past a what-if with `delete > 0` without explicit user confirmation.
- Circuit breaker at 10 iterations — escalate to the user with the unresolved delta.
