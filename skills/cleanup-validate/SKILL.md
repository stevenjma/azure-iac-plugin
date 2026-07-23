---
name: cleanup-validate
description: >
  Use this skill when the user asks to validate or dry-run imported Terraform against live Azure,
  or as the final terraform-cleanup gate. Run validate and read-only plan for at most 10 iterations
  until zero drift or only documented intentional drift remains. Always require the checklist and
  upstream evidence artifacts, including for validate-only use.
license: MIT
---

## Goal

Confirm the refined HCL produces `0 to add, 0 to destroy, 0 to change` (or only
explicitly accepted intentional changes) against live infrastructure.

## Hard precondition (do not skip)

Before running `terraform validate`, execute the gate commands below **in this turn**
(the tool-call output is the evidence; the agent cannot claim the gate passed
without the matching output in the transcript).

### Gate A: Checklist completeness

Read `<workdir>/.cleanup/checklist.json`. Refuse to proceed unless every required
upstream pass has `status ∈ {"complete", "skipped"}` AND every `skipped` entry has
a non-empty `reason`:

```
required_upstream = [
  "3.1-references", "3.2-variables", "3.3-prune",
  "3.3.5-consolidate", "3.4-organize", "3.5-secrets",
]
```

### Gate B: Working-tree cross-checks

Run each check using your built-in **grep tool** (the same tool you use for
codebase search — not a shell command, so this works on Windows, macOS, and
Linux). For path-listing checks, use the **view** or **glob** tool. Capture
the tool output in the same turn as the validate result.

| Check | Tool invocation | Expected |
|---|---|---|
| No literal subscription IDs | grep pattern `"/subscriptions/[0-9a-fA-F-]+/` against `<workdir>/*.tf`, **excluding** `variables.tf`, `outputs.tf`, `providers.tf` (apply the exclusion via the tool's path/glob argument or post-filter the hits) | 0 unjustified hits (each remaining hit must appear in `references.json` `literal_ids_remaining_locations`) |
| variables.tf exists | glob `<workdir>/variables.tf` | file exists (unless mode=partial and `cleanup-variables` legitimately skipped) |
| Mandatory variables present | grep pattern `^variable +"(subscription_id\|location\|resource_group_name\|tags)"` against `<workdir>/variables.tf` (regex alternation; one match per name) | 4 hits (or each absentee declared in `variables.json` `skipped` with a reason) |
| No `res-N` addresses | grep pattern `^resource +"[^"]+" +"res-?[0-9]+"` against `<workdir>/*.tf` | 0 hits |
| Secrets template if secrets identified | glob `<workdir>/secrets.auto.tfvars.example` | file exists when `secrets.json` `secrets_identified` is non-empty |
| moved blocks match consolidate claims | grep with `output_mode: count` for pattern `^moved \{` across `<workdir>/*.tf`; sum counts | ≥ sum of `moved_blocks_emitted` across `consolidate.json` `groups_consolidated` |

### Gate C: Mode-selection audit (non-`full` modes only)

If `checklist.json` `mode != "full"`, read `<workdir>/.cleanup/intake.json` and
confirm `mode_selection_quote` is present and non-empty (the verbatim user
utterance that selected the non-full mode). Refuse to proceed otherwise — do not
infer consent.

These checks are the gate. Do not summarize "all gates pass" without each
command's output visible in the same turn.

## Procedure

1. Run **Gates A, B, C** above. If any fails, stop.
2. `terraform init` (if `.terraform/` missing).
3. `terraform validate`. If it fails, categorize:
   - Schema error → invoke `azure-to-terraform-translation` for the matching rule.
   - Reference error → return to `cleanup-references`.
   - Type error → fetch provider docs, fix, repeat.
4. `terraform plan` with placeholder vars for secrets.
5. Categorize the plan output:
   - `0 to add, 0 to destroy, 0 to change` → **success**.
   - Only intentional drift (write-only placeholders, materialized defaults) → **success
     with notes**.
   - Unexpected changes → invoke `azure-to-terraform-translation` for the matching rule.
   - **Any destroys** → STOP, do not iterate. Surface to user.
6. Loop until success or 10 iterations.
7. Before marking the pass complete, re-run Gate B once more and include its output
   in the final summary.

## Drift categories (auto-fixable)

| Category | Example | Fix |
|---|---|---|
| Enum shorthand | KV `"all"` permissions | Expand to full list (translation Rule 1.1) |
| ID format mismatch | `/shares/` vs `/fileshares/` | String interpolation + `ignore_changes` (Rule 5.x) |
| Write-only placeholder | `account_key = "placeholder"` | `ignore_changes` (or ephemeral) |
| Default materialization | `ip_restriction_default_action: "" → "Allow"` | Set explicitly (Rule 1.6) |
| Computed in config | Export includes `id` | Remove (`cleanup-prune`) |

## Acceptance Criteria (mandatory)

Write `<workdir>/.cleanup/validate.json`:

```json
{
  "pass": "4-validate",
  "status": "complete",
  "terraform_validate": "pass",
  "iterations": 2,
  "final_plan": { "add": 0, "change": 1, "destroy": 0 },
  "intentional_changes": [
    { "address": "azurerm_linux_web_app.site", "field": "site_config.ip_restriction_default_action", "reason": "provider materializes default Allow" }
  ],
  "gate_b_output_in_turn": true
}
```

The pass is **not complete** unless:
- Gates A, B, C output appears in the same turn as the success summary.
- `terraform_validate == "pass"`.
- `final_plan.destroy == 0`.
- Every `change` is in `intentional_changes` with a `reason`.

## Guardrails

- Never run `terraform apply`.
- Never proceed past a plan with `destroy > 0` without explicit user confirmation.
- Circuit breaker at 10 iterations — escalate to the user with the unresolved error.
