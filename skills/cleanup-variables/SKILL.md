---
name: cleanup-variables
description: >
  Use this skill only during terraform-cleanup Pass 3.2, or when the user explicitly asks to
  parameterize exported Terraform. Extract repeated locations, names, tags, SKUs, and scope values
  into typed, documented variables without hardcoding subscription IDs.
license: MIT
---

## Goal

Produce a `variables.tf` containing at minimum the canonical four variables, plus any
value that appears 3+ times across the codebase.

## Mandatory Variables

| Variable | When required | Default |
|----------|---------------|---------|
| `subscription_id` | Always (extracted from provider block) | the value detected, asked from user |
| `location` | If 2+ resources share a location | the value detected |
| `resource_group_name` | If 2+ resources share an RG | the value detected (or `null` if multi-RG) |
| `tags` | If any resource has tags | `{}` (map(string)) |

## Heuristic for additional variables

A value is a variable candidate when **any** of:
- It is a secret/credential placeholder (handled by `cleanup-secrets` — exclude here).
- It is a SKU/tier/size literal that appears with a `name`/`tier`/`size` argument.
- It is a string literal that appears verbatim 3+ times across files.
- It is an environment-specific name (CIDR, FQDN, account name) the user identifies in intake.

## Procedure

1. Read the orchestrator's `intake.json` for explicit variable hints from the user.
2. Build a frequency map of every string literal across `.tf` files (excluding existing
   `variables.tf`, `outputs.tf`, `*.tfvars*`).
3. Apply the mandatory + heuristic rules above.
4. Generate or update `variables.tf` with each variable's `description`, `type`, `default`
   (where sensible), and `validation` block (for constrained values).
5. Rewrite every literal occurrence to `var.<name>`.
6. Verify with grep that the literal no longer appears outside `variables.tf`.

## Acceptance Criteria (mandatory)

Write `<workdir>/.cleanup/variables.json`:

```json
{
  "pass": "3.2-variables",
  "status": "complete",
  "variables_created": ["subscription_id", "location", "resource_group_name", "tags"],
  "variables_extracted_count": 6,
  "occurrences_rewritten": 47,
  "skipped": [
    { "value": "westus2", "occurrences": 1, "reason": "single use" }
  ]
}
```

The pass is **not complete** unless:
- `variables.tf` exists.
- All four mandatory variables are present **OR** marked `skipped` with a justification.

## Non-goals

- Secrets — `cleanup-secrets` owns those. Do not touch `null # sensitive` here.
- Computed attribute pruning — `cleanup-prune` owns that.

## Guardrails

- Never set a `default` for a value the user hasn't confirmed (ask, then default to the
  detected value).
- Never extract a value the orchestrator's intake explicitly marked as "keep literal".
