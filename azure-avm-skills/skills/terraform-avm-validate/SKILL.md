---
name: terraform-avm-validate
description: >
  terraform-avm-compose Phase 4 — run `terraform fmt -check`/`terraform validate` (syntax gate) then
  `terraform plan` against the live estate (fidelity gate, pure local Terraform CLI — never ARM MCP)
  in a loop until "no changes" (or only reconciled intentional drift) is reached. Hard-gated on the
  compose checklist AND the reconciliation ledger; refuses to run if upstream passes did not produce
  their artifacts. Max 10 plan iterations.
license: MIT
---

## Goal

Confirm the composed AVM Terraform (a) formats and validates clean (**syntax gate**), and (b)
produces a `terraform plan` against the live estate whose only non-empty change lines are
**reconciled `adopt` decisions** (**fidelity/reconcile gate**). Because the code is AVM module calls
plus `import` blocks, a clean plan proves the modules — with the oracle-wired inputs — adopt and
reproduce the live estate, and any remaining change is a deliberate posture uplift the operator
signed off in `reconciliation.json`. This is the AVM counterpart of the raw lane's validate gate,
plus a ledger cross-check the raw lane does not need.

## Hard precondition (do not skip)

Before running `terraform plan`, execute the gate commands below **in this turn** (the tool-call
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
| Modules use pinned AVM sources | grep pattern `Azure/avm-res-` against `<workdir>/**/*.tf` | ≥1; every module has an explicit `version = "x.y.z"` |
| No floating module versions | grep pattern `version\s*=\s*"[~>= ]` or `latest` against `*.tf` | 0 hits (exact pins only, no `~>`) |
| Import blocks present | grep pattern `import\s*\{` against `<workdir>/**/*.tf` | ≥1, and every in-scope live resource has a matching `import` block — a planned `+ create` (see Acceptance) signals a missing one |
| No literal subscription IDs | grep pattern `/subscriptions/[0-9a-fA-F-]{36}` against `*.tf` | 0 hits **outside** `import` block `id` fields (imports legitimately carry the live resource ID; module cross-refs must be symbolic `module.*`) |
| Sensitive inputs are sensitive, no literals | grep `sensitive\s*=\s*true` count ≥ `secrets.json.sensitive_vars_declared`; grep for `password\s*=\s*"`, `AccountKey=`, `SharedAccessKey` | sensitive count matches; 0 literal-secret hits |
| Formats + validates | run `terraform fmt -check` then `terraform init -backend=false && terraform validate` | exit 0 |

### Gate C: Mode-selection audit (non-`full` modes only)

If `checklist.json` `mode != "full"`, read `<workdir>/.avm/intake.json` and confirm
`mode_selection_quote` is present and non-empty. Refuse to proceed otherwise — do not infer consent.

### Gate D: Reconciliation-ledger completeness (AVM-specific)

Read `<workdir>/.avm/reconciliation.json`. Refuse to proceed unless:
- It exists and every entry has `module`, `variable`, `live`, `avm_default`, `chosen`, `decision`
  (`adopt` | `pin`), and a non-empty `reason`.
- Every `pin` entry's `chosen == live` (a pin that doesn't reproduce live is a defect).
- Every `adopt` entry's `chosen == avm_default` and carries a `rule` citation.
This ledger is the map the fidelity gate uses to classify plan lines. A plan `~ update in place` with
no matching `adopt` entry is a failure, not "intentional drift".

These checks are the gate. Do not summarize "all gates pass" without each command's output visible
in the same turn.

## Procedure

1. Run **Gates A, B, C, D**. If any fails, stop.
2. **Syntax gate** — `terraform fmt -check` (format) and `terraform init -backend=false` +
   `terraform validate` (validate). If either fails, categorize:
   - Missing/typed module input → re-read the module variable schema and fix the mapping
     (return to `terraform-avm-inputs`, which owns ARM-property → variable translation).
   - Symbol/reference error → return to `terraform-avm-map` or `terraform-avm-organize`.
   - Module install failure → confirm the pinned version exists (re-run `avm-module-resolver`
     version resolution); never downgrade to floating.
3. **Fidelity/reconcile gate** — run `terraform plan` against the live estate:
   - `terraform init` (install modules + provider), then `terraform plan` — **pure local Terraform
     CLI**. The azurerm provider reads live Azure via the caller's own credentials; because 3.1
     emitted `import` blocks, plan resolves them and a faithful adoption shows resources under "will
     be imported" with no in-place changes. **Never** use ARM MCP `whatif_deployment` here — that is
     the Bicep lane's engine; the Terraform lane's fidelity gate is the provider's own plan.
4. **Classify every plan line against the ledger:**
   - Import-only / no-op (resource imported, no attribute changes) → success.
   - `~ update in place` that matches an `adopt` entry (same module + variable + live→avm_default
     delta) → **intentional**; keep, cite the ledger entry.
   - `~ update in place` that matches a `pin` entry, or matches nothing → **defect**: the pinned
     live value did not reproduce. Re-map the input (return to `terraform-avm-inputs`). Do not
     reclassify it as intentional.
   - Sensitive-placeholder `update` (from example tfvars values) → intentional; note it.
   - **Any `- destroy` or `-/+ replace`** → STOP, do not iterate. Surface to user (a destroy/replace
     means a live resource is not faithfully represented — likely a `defer` gap or a wrong import id).
5. Loop until success or 10 iterations.
6. Before marking complete, re-run Gate B and Gate D once more and include their output in the
   final summary.

## Drift categories

| Category | Example | Fix / classification |
|---|---|---|
| Adopt uplift (expected) | `allow_blob_public_access` live→AVM-default | Intentional — must match an `adopt` ledger entry (Rule A5.x) |
| Pin not reproduced (defect) | live `min_tls_version` not applied | Fix input mapping — Rule A2.x / A3.x (`terraform-avm-inputs`) |
| Curated-input mismatch | ARM property mapped to wrong module variable | Re-map the input — Rule A1.x (`terraform-avm-inputs`) |
| Missing required input | module default overrode live | Wire the live value — `terraform-avm-inputs` |
| Sensitive placeholder diff | example tfvars forces `update` on a key | Accept as intentional; note it |
| Replace / destroy | wrong import id, or live resource absent from composition | STOP — a `defer`/gap or import mismatch |
| Net-new create (defect) | live resource planned as `+ create` (missing `import` block) | STOP — an existing resource must be imported, not created |

## Acceptance Criteria (mandatory)

Write `<workdir>/.avm/validate.json`:

```json
{
  "pass": "4-validate",
  "status": "complete",
  "terraform_fmt": "pass",
  "terraform_validate": "pass",
  "plan_engine": "terraform plan",
  "iterations": 2,
  "final_plan": { "import": 13, "add": 0, "change": 1, "destroy": 0 },
  "intentional_changes": [
    { "module": "storage_account_sa1", "variable": "allow_blob_public_access",
      "ledger_decision": "adopt", "rule": "A5.2", "reason": "AVM secure default; reconciled" }
  ],
  "ledger_lines_matched": true,
  "gate_b_output_in_turn": true,
  "gate_d_output_in_turn": true
}
```

The pass is **not complete** unless:
- Gates A, B, C, D output appears in the same turn as the success summary.
- `terraform_fmt == "pass"` and `terraform_validate == "pass"`.
- `final_plan.destroy == 0` (and no `replace`).
- `final_plan.add == 0` — a brownfield adoption plan is import-only; any `+ create` means a missing
  `import` block or composition gap. STOP unless it maps to a deliberate, ledgered net-new.
- Every `change` line maps to an `adopt` entry in `reconciliation.json` (`ledger_lines_matched: true`);
  no `pin` produced drift.

## Guardrails

- Never run `terraform apply`. Plan is read-only.
- Never reclassify an unreconciled `update` as "intentional" — it must have an `adopt` ledger entry.
- Never proceed past a plan with `destroy > 0` (or a `replace`) without explicit user confirmation.
- Never resolve a module install failure by floating the version — re-pin via the resolver.
- Never use ARM MCP for the fidelity gate — the Terraform lane validates with `terraform plan`.
- Circuit breaker at 10 iterations — escalate to the user with the unresolved delta.
