---
name: cleanup-consolidate
description: >
  Use this skill during terraform-cleanup Pass 3.3.5 to consolidate repeated Terraform resources.
  Replace safe groups of near-identical blocks with for_each or count and preserve state addresses
  with moved blocks.
license: MIT
---

## Goal

Detect groups of near-identical resources of the same type and consolidate them into
one resource block using `for_each` keyed by the differing field. Always emit `moved {}`
blocks so the refactor is a pure state migration with zero replacements.

## When to consolidate (deterministic trigger)

Consolidate a group of resources when **all** of:

1. There are ≥ 3 resources of the same `type` in the working directory.
2. They share ≥ T% of their argument values literally, where T scales with size:
   - 3–4 members: T = 80%
   - 5–9 members: T = 70%
   - ≥ 10 members: T = 60%
3. The differing values can be expressed as a keyed map (string → object).
4. None of them have unique `lifecycle` / `provisioner` / `depends_on` clauses that
   would diverge per-instance.

### How to compute the shared-arg ratio

- **Denominator**: the union of top-level argument *names* across all members.
- **Numerator**: count of names whose value is identical across every member.
- **Nested blocks** are compared as a full subtree (structural equality of all
  keys and values). A nested block counts as one name in both numerator and
  denominator.
- **Arguments present in some members but not others** count in the denominator
  but not the numerator (they vary).
- **Maps** (e.g. `tags`) are compared structurally, not as strings.

Worked example: 39 `azurerm_log_analytics_saved_search` resources, each with
6 top-level args (`solution_solution_id`, `category`, `display_name`, `query`,
`name`, `log_analytics_workspace_id`). 5 of 6 are identical across all members
(`query` differs). Ratio = 5/6 = 83% → trigger fires.

Common targets on real aztfexport output:
- `azurerm_log_analytics_saved_search` (auto-created per workspace, often 30+)
- `azurerm_monitor_diagnostic_setting` (one per resource)
- `azurerm_role_assignment` (per principal/scope pair)
- `azurerm_private_endpoint` (per subnet/target pair)
- `azurerm_subnet` (when many subnets share an NSG/route table pattern)

## Procedure

1. Group all resource declarations by `type`. Skip groups with < 3 members.
2. For each group, compute the set of arguments and their values across members.
3. Identify the **stable** arguments (same value across all members) and the
   **varying** arguments (differ across members).
4. If stable args >= 80% of total args, propose consolidation:
   - The keyed map is `for_each = local.<type_plural>` defined in `locals.tf`
     (or `variables.tf` if user-facing).
   - The varying args reference `each.value.<arg>`.
   - The key is the most stable unique field (display name, or the Azure resource name).
5. Emit:
   - A consolidated resource block.
   - A `local` map containing every member's varying args.
   - A `moved {}` block for every original resource address, e.g.:
     ```hcl
     moved {
       from = azurerm_log_analytics_saved_search.alert_disk_full
       to   = azurerm_log_analytics_saved_search.saved["alert_disk_full"]
     }
     ```
6. Run `terraform validate` then `terraform plan`; the plan **must** show
   `0 to add, 0 to destroy` for the consolidated group.

## Acceptance Criteria (mandatory)

Write `<workdir>/.cleanup/consolidate.json`:

```json
{
  "pass": "3.3.5-consolidate",
  "status": "complete",
  "groups_consolidated": [
    {
      "type": "azurerm_log_analytics_saved_search",
      "members_before": 39,
      "members_after": 1,
      "moved_blocks_emitted": 39,
      "key_field": "name"
    }
  ],
  "groups_skipped": [
    {
      "type": "azurerm_subnet",
      "members": 4,
      "reason": "stable arg ratio 62% — below 80% threshold"
    }
  ],
  "plan_destroys_for_consolidated_groups": 0
}
```

The pass is **not complete** unless:
- `plan_destroys_for_consolidated_groups == 0`.
- Every original resource address has a matching `moved {}` block.

## When NOT to consolidate

- The user explicitly says "keep them flat" in intake.
- Members have meaningfully different `lifecycle` rules.
- Members reference each other (creates `for_each` cycles).
- The set is < 3 members.

## Non-goals

- Splitting files (`cleanup-organize` comes after).
- Renaming `res-N` (also `cleanup-organize`).
