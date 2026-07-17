---
name: terraform-avm-organize
description: >
  terraform-avm-compose Phase 3.3 — organize composed AVM module blocks into a clean Terraform file
  layout: extract shared values to variables/locals, group related modules, and decide single-vs-
  multi-file. Lighter than raw cleanup because AVM modules already encapsulate resource detail.
  Legitimately reports "skipped" for small estates. Writes organize.json.
license: MIT
---

## Goal

Make the composed Terraform readable and maintainable **without changing what it deploys**. Because
each module block is already a compact, encapsulated unit, this pass is far lighter than the raw
lane's prune/consolidate/organize passes — there are no computed attributes to strip and no deep
resource bodies to reshape. Focus on layout, shared inputs, and surfaced outputs.

## Preconditions

- Pass 3.2 (`terraform-avm-inputs`) reports `complete`.
- `map.json` (module labels + import blocks) and `inputs.json` exist.

## Procedure

1. **Extract shared values to variables/locals.** Values repeated across modules — `location`,
   `resource_group_name`, tags, a Log Analytics workspace `resource_id` — become `variable` blocks
   (with the live value as `default` where appropriate) or `locals`, referenced by every module.
   Preserves values exactly; improves single-point-of-change.
2. **Group related modules.** Order/group by dependency and domain (network, then compute, then
   data). `for_each` over a map is appropriate when ≥3 modules of the same type share ≥80% of their
   inputs; otherwise keep them explicit (readability beats premature DRY). Keep every `import` block
   adjacent to (or clearly associated with) its module so adoption stays legible.
3. **Decide file layout:**
   - Small estate (≤ ~6 modules) → a single `main.tf` (+ `variables.tf`, `outputs.tf`,
     `imports.tf`) is correct. Splitting further is *skippable* — record `status: "skipped"` with a
     reason. Do not invent files to look busy.
   - Larger → split by domain (`network.tf`, `compute.tf`, `data.tf`), keeping
     `variables.tf`/`outputs.tf`/`imports.tf`/`providers.tf` central.
4. **Surface outputs.** Re-export the module outputs a consumer needs (`resource_id`, `name`,
   endpoints) as top-level `output` blocks. Never output secret-typed values (3.4 marks them
   `sensitive`).
5. **Confirm no value changed** — `terraform fmt` + `terraform validate` still pass; refactor only.

## Guardrails

- Never change a wired value or an AVM-default reconciliation decision (3.2 owns those).
- Never drop or relocate an `import` block such that its module loses adoption.
- `status: "skipped"` (with reason) is a legitimate, common outcome for small estates — do not
  fabricate a multi-file split.
- Never surface a secret as an output.
- Refactor only: `terraform validate` must stay green.

## Acceptance Criteria

Write `<workdir>/.avm/organize.json`:

```json
{
  "pass": "3.3-organize",
  "status": "complete",
  "shared_variables_extracted": ["location", "resource_group_name", "tags"],
  "grouping": "for_each over 4 storage accounts; network/compute/data split",
  "files": ["providers.tf", "network.tf", "data.tf", "variables.tf", "outputs.tf", "imports.tf"],
  "outputs_surfaced": ["storage_account_ids", "key_vault_uri"],
  "values_changed": false
}
```

Or, legitimately:

```json
{ "pass": "3.3-organize", "status": "skipped",
  "reason": "3 modules; single main.tf appropriate; no split warranted", "values_changed": false }
```

Not complete unless `values_changed` is `false`, `terraform validate` still passes, no `import`
block was orphaned, no secret is surfaced as an output, and `checklist.json` pass `3.3-organize` is
`complete` or `skipped` with a reason.

## Non-goals

- Wiring values (3.2). Secrets (3.4). Plan (4). There is no attribute-pruning step — AVM modules
  never expose the computed/read-only ARM properties the raw lane must strip.
