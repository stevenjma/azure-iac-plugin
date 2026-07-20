---
name: bicep-avm-validate
description: >
  bicep-avm-compose Phase 4 — run `az bicep build`/lint (syntax gate) then ARM MCP whatif_deployment
  (or `az deployment group what-if` fallback) in a loop until "no changes" (or only reconciled
  intentional drift) is reached. Hard-gated on the compose checklist AND the reconciliation ledger;
  refuses to run if upstream passes did not produce their artifacts. Max 10 what-if iterations.
license: MIT
---

## Goal

Confirm the composed AVM Bicep (a) compiles and lints clean (**syntax gate**), and (b) produces a
what-if against the live resource group whose only non-empty lines are **reconciled `adopt`
decisions** (**fidelity/reconcile gate**). Because the code is AVM module calls, a clean what-if
proves the modules — with the oracle-wired inputs — reproduce the live estate, and any remaining
drift is a deliberate posture uplift the operator signed off in `reconciliation.json`. This is the
AVM counterpart of the raw lane's build + what-if gate, plus a ledger cross-check the raw lane
does not need.

## Hard precondition (do not skip)

Before running `az bicep build`, execute the gate commands below **in this turn** (the tool-call
output is the evidence; the agent cannot claim a gate passed without the matching output in the
transcript).

### Gate A: Checklist completeness

Read `<workdir>/.avm/checklist.json`. Refuse to proceed unless every required upstream pass has
`status ∈ {"complete", "skipped"}` AND every `skipped` entry has a non-empty `reason`:

```
required_upstream = [ "3.1-map", "3.2-inputs", "3.3-organize", "3.4-secrets" ]
```

### Gate B: Working-tree cross-checks

Run each check using your built-in **grep tool** (not a shell command, so it works cross-platform).
For path-listing checks use **view**/**glob**. Capture the tool output in the same turn as the
validate result.

| Check | Tool invocation | Expected |
|---|---|---|
| Modules use pinned AVM sources | grep pattern `br/public:avm/res/` against `<workdir>/**/*.bicep` | ≥1; every hit has an explicit `:<x.y.z>` version (no floating) |
| No floating module versions | grep pattern `br/public:avm/[^:]+:(latest\|\*)` | 0 hits |
| No literal subscription IDs | grep pattern `/subscriptions/[0-9a-fA-F-]{36}` against `<workdir>/**/*.bicep` | 0 unjustified hits (cross-references must be symbolic `module.outputs.*`) |
| Secure inputs are @secure(), no literals | grep pattern `@secure\(\)` count ≥ `secrets.json.secure_params_declared`; grep for `password\s*[:=]\s*'`, `AccountKey=`, `SharedAccessKey` | secure count matches; 0 literal-secret hits |
| No raw ARM property blind-copy leaks | grep pattern `provisioningState\|"?id"?:\s*'/subscriptions` against `<workdir>/**/*.bicep` | 0 hits (module inputs are curated, not raw ARM bodies) |
| Compiles | run `az bicep build --file <workdir>/main.bicep --stdout` | exit 0 |

### Gate C: Mode-selection audit (non-`full` modes only)

If `checklist.json` `mode != "full"`, read `<workdir>/.avm/intake.json` and confirm
`mode_selection_quote` is present and non-empty. Refuse to proceed otherwise — do not infer consent.

### Gate D: Reconciliation-ledger completeness (AVM-specific)

Read `<workdir>/.avm/reconciliation.json`. Refuse to proceed unless:
- It exists and every entry has `module`, `param`, `live`, `avm_default`, `chosen`, `decision`
  (`adopt` | `pin`), and a non-empty `reason`.
- Every `pin` entry's `chosen == live` (a pin that doesn't reproduce live is a defect).
- Every `adopt` entry's `chosen == avm_default` and carries a `rule` citation.
This ledger is the map the fidelity gate uses to classify what-if lines. A what-if `Modify` with no
matching `adopt` entry is a failure, not "intentional drift".

These checks are the gate. Do not summarize "all gates pass" without each command's output visible
in the same turn.

## Procedure

1. Run **Gates A, B, C, D**. If any fails, stop.
2. **Syntax gate** — `az bicep build --file main.bicep` (compile) and `az bicep lint --file
   main.bicep` (lint). If either fails, categorize:
   - Missing/typed module input → re-read the module input schema and fix the mapping (return to
     `bicep-avm-inputs`, which owns ARM-property → param translation).
   - Symbol/reference error → return to `bicep-avm-map` or `bicep-avm-organize`.
   - Module restore failure → confirm the pinned version exists (re-run `avm-module-resolver`
     version resolution); never downgrade to floating.
3. **Fidelity/reconcile gate** — run what-if against the live RG:
   - **Preferred:** ARM MCP `whatif_deployment` (governed, caller RBAC) — compiled template +
     parameters + target resource group.
   - **Fallback:** `az deployment group what-if --resource-group <rg> --template-file main.bicep
     --parameters @secrets.parameters.example.json` (placeholder secure values). Record which was used.
4. **Classify every what-if line against the ledger:**
   - `NoChange`/`Ignore` → success.
   - `Modify` that matches an `adopt` entry (same module + param + live→avm_default delta) →
     **intentional**; keep, cite the ledger entry.
   - `Modify` that matches a `pin` entry, or matches nothing → **defect**: the pinned live value did
     not reproduce. Re-map the input (return to `bicep-avm-inputs`). Do not reclassify it as intentional.
   - Secure-placeholder `Modify` (from `@secure()` example values) → intentional; note it.
   - **Any `Delete`** → STOP, do not iterate. Surface to user (a delete means a live resource is not
     represented — likely a `defer` gap that should not have been deferred).
5. Loop until success or 10 iterations.
6. Before marking complete, re-run Gate B and Gate D once more and include their output in the
   final summary.

## Drift categories

| Category | Example | Fix / classification |
|---|---|---|
| Adopt uplift (expected) | `allowBlobPublicAccess` live→AVM-default | Intentional — must match an `adopt` ledger entry (Rule A5.x) |
| Pin not reproduced (defect) | live `minimumTlsVersion` not applied | Fix input mapping — Rule A2.x / A3.x (`bicep-avm-inputs`) |
| Curated-input mismatch | ARM property mapped to wrong module param | Re-map via `bicep-avm-inputs` — Rule A1.x |
| Missing required input | module default overrode live | Wire the live value — `bicep-avm-inputs` |
| Secure placeholder diff | `@secure()` forces `Modify` on a key | Accept as intentional; note it |
| Delete | live resource absent from composition | STOP — a `defer`/gap was mis-handled |
| Net-new create (defect) | live resource shows as `Create` in what-if (composition doesn't match a live resource) | STOP — an in-scope live resource must reconcile to `NoChange`/`Modify`, not `Create` |

## Acceptance Criteria (mandatory)

Write `<workdir>/.avm/validate.json`:

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
    { "module": "storageAccount", "param": "allowBlobPublicAccess",
      "ledger_decision": "adopt", "rule": "A5.2", "reason": "AVM secure default; reconciled" }
  ],
  "ledger_lines_matched": true,
  "gate_b_output_in_turn": true,
  "gate_d_output_in_turn": true
}
```

The pass is **not complete** unless:
- Gates A, B, C, D output appears in the same turn as the success summary.
- `bicep_build == "pass"` and `bicep_lint == "pass"`.
- `final_whatif.delete == 0`.
- `final_whatif.create == 0` — a brownfield adoption what-if reconciles against live resources; any
  `Create` means the composition doesn't match a live resource. STOP unless it maps to a deliberate,
  ledgered net-new.
- Every `modify` line maps to an `adopt` entry in `reconciliation.json` (`ledger_lines_matched: true`);
  no `pin` produced drift.

## Guardrails

- Never run `az deployment group create` (apply). What-if is read-only.
- Never reclassify an unreconciled `Modify` as "intentional" — it must have an `adopt` ledger entry.
- Never proceed past a what-if with `delete > 0` without explicit user confirmation.
- Never resolve a restore failure by floating the version — re-pin via the resolver.
- Circuit breaker at 10 iterations — escalate to the user with the unresolved delta.
