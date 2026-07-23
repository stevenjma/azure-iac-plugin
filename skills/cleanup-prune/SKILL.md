---
name: cleanup-prune
description: >
  Use this skill only during terraform-cleanup Pass 3.3, or when the user explicitly asks to prune
  exported Terraform. Remove computed-only attributes, redundant provider defaults, empty blocks,
  and invalid empty-string enums while preserving configured Azure behavior.
license: MIT
---

## Goal

Shrink each resource declaration to only attributes that materially differ from the
provider default. Eliminate aztfexport artifacts that would cause plan failures
or perpetual drift.

## What to remove

| Category | Example | Why |
|---|---|---|
| Computed-only attributes | `id = "..."`, `primary_key = "..."` | Provider populates from API |
| Optional at default | `enabled = true` when default is `true` | Noise |
| Empty blocks | `identity {}`, `timeouts {}` | aztfexport noise |
| Empty-string enums | `ip_restriction_default_action = ""` | Provider validation rejects |

## Empty-string enum handling (critical)

For each `<field> = ""` on an enum-constrained attribute:

1. Look up the documented default via the constraint map (or provider schema docs / `terraform providers schema -json`).
2. If a default exists → replace `""` with the documented default value.
3. If no default exists → delete the line and let the provider supply its own default.

Common known triggers:
- `ip_restriction_default_action = ""` → `"Allow"`
- `scm_ip_restriction_default_action = ""` → `"Allow"`
- `public_network_access = ""` → `"Enabled"`

See translation skill Rule 1.6 for the full pattern.

## What to preserve

- Any attribute differing from the documented provider default.
- Lifecycle blocks (`ignore_changes`, `prevent_destroy`).
- Attributes the user explicitly set during intake.
- Tags, even if `{}` — pruning tags causes plan drift when Azure injects service tags.

## Procedure

1. Load the orchestrator's constraint map for every resource type in scope.
2. For each resource, walk every attribute:
   - If computed-only per schema → remove.
   - If optional and value matches documented default → remove.
   - If empty block with no nested values → remove.
   - If empty-string on an enum field → apply the handling above.
3. Re-run `terraform validate` to confirm no syntax break.

## Acceptance Criteria (mandatory)

Write `<workdir>/.cleanup/prune.json`:

```json
{
  "pass": "3.3-prune",
  "status": "complete",
  "attributes_removed": 134,
  "empty_blocks_removed": 12,
  "empty_string_enums_fixed": 4,
  "remaining_empty_strings": [],
  "terraform_validate": "pass"
}
```

The pass is **not complete** unless:
- `remaining_empty_strings == []` (or each entry justified with a reason).
- `terraform_validate == "pass"`.

## Non-goals

- Splitting files (`cleanup-organize`).
- Reference injection (`cleanup-references`).
- Variable extraction (`cleanup-variables`).
