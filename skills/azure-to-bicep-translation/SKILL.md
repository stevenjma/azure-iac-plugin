---
name: azure-to-bicep-translation
description: >
  Use this skill when exported or decompiled Bicep fails to build or produces unexpected ARM what-if
  changes. Diagnose and correct Azure export/decompile mismatches involving defaults, read-only
  properties, resource IDs, enum syntax, casing, and API-version drift.
license: MIT
metadata:
  version: "1.0"
  author: Stephen Ma
---

> **Purpose**: Fix the semantic mismatch between the ARM JSON that `exportTemplate` returns
> (decompiled to Bicep) and the shape a faithful, drift-free deployment expects. The Bicep
> counterpart of `azure-to-terraform-translation`, deliberately lean.

## Prerequisites

Works best with a **schema doc source** for enum/default/readOnly lookups:
- **ARM MCP** `get_resource_type_schema` (or `az provider show --namespace <ns> --expand
  resourceTypes`) to confirm the live Azure-side shape of a field.
- Bicep type definitions (`az bicep build` diagnostics reference them).

Use these to look up: valid enum values, whether a property is readOnly/computed, and the
platform default when a property was omitted server-side but materializes in what-if.

## When to Invoke

Called by `bicep-validate` (or directly) whenever:
- `az bicep build` / `az bicep lint` fails on the decompiled template.
- `whatif_deployment` (or `az deployment group what-if`) shows an unexpected `Modify`.
- A property shows perpetual drift on a value that has not actually changed.

## Architecture

```
Live RG → exportTemplate → ARM JSON → bicep decompile → Raw Bicep (drifty) → THIS SKILL → Faithful Bicep
```

The core problem: `exportTemplate` captures a **point-in-time materialized** view (readOnly props,
provider-filled defaults, canonicalized IDs). A clean redeploy would not author those, so what-if
reports deltas that are **not real changes** — they are export-materialization artifacts.

---

## Rule B1 — Default materialization

Export captured a value the platform filled in; the source template never set it. What-if compares
the live (materialized) value against your template and flags a diff either way.

- **B1.1 Omit-vs-default:** If a property equals the documented platform default and the source
  intent was "unset", remove it. (e.g. `supportsHttpsTrafficOnly: true` when it's the default.)
- **B1.2 Explicit-default:** If the value is load-bearing (security posture like
  `minimumTlsVersion: 'TLS1_2'`), keep it **explicit** even if it equals the default — a faithful,
  self-documenting template. Note it in `validate.json intentional_changes` if it forces a diff.
- **B1.3 Empty collections:** Drop `[]`/`{}` the platform materializes for unset optional
  collections (e.g. empty `ipRules`, `virtualNetworkRules`).

## Rule B2 — ReadOnly / computed copy-through

Decompile faithfully copies output-only fields into the resource body; redeploy must not author
them. These are the highest-frequency what-if noise source.

- **B2.1 Strip readOnly:** Remove `id`, `provisioningState`, `etag`, `type` (inside body),
  `resourceGuid`, timestamps, and any field the schema marks `readOnly: true`.
- **B2.2 Nested readOnly:** Recurse into nested objects/arrays (e.g. `properties.endpoints[].id`,
  `subnets[].properties.provisioningState`).
- **B2.3 apiVersion normalization:** Decompile may pin an old `@apiVersion`. A stale version can
  report property deltas that vanish on the current version. Normalize to a current, supported
  apiVersion for the type (confirm via schema). Overlaps with `bicep-prune`.

## Rule B3 — ID / case / reference format

- **B3.1 Rebuild references:** Replace literal `/subscriptions/…/resourceGroups/…/providers/…`
  strings with symbolic references (`<symbol>.id`) or `resourceId()` so casing/format matches what
  ARM emits — hard-coded IDs frequently differ in case and report false drift.
- **B3.2 Scope functions:** Replace literal subscription/RG segments with `subscription().id` /
  `resourceGroup().id` — coordinates with `bicep-parameterize` Rule set.
- **B3.3 Child-resource naming:** Use parent/child symbolic nesting or the `parent:` property
  rather than concatenated `'parent/child'` name strings, which decompile sometimes flattens.

## Rule B4 — Enum & shorthand normalization

- **B4.1 Enum casing:** Azure returns enums in a canonical case the schema may reject or that
  differs from what what-if expects (e.g. `Standard_LRS` vs `standard_lrs`). Normalize to the
  schema's exact casing.
- **B4.2 SKU shorthand:** Decompile may split a SKU into verbose `{ name, tier }` when only `name`
  is needed (tier is derivable) — collapse to what the type expects to avoid a materialized-tier
  diff.
- **B4.3 Numeric-vs-string:** Some properties round-trip as strings in ARM JSON but are typed
  numeric/bool in Bicep — let decompile's typing stand; do not re-quote.

## Rule B5 — Structural / decompile artifacts

- **B5.1 Generated symbol cleanup:** Decompile emits `param_*` / `var_*` / `resource_*` names for
  things it couldn't name. Rename to intent-revealing identifiers (coordinates with `bicep-prune`
  and `bicep-parameterize`).
- **B5.2 dependsOn pruning:** Remove explicit `dependsOn` that a symbolic reference already
  implies — redundant but not drift-causing; improves readability.
- **B5.3 Decompile warnings:** Triage every `az bicep decompile` warning (e.g. "unable to convert
  expression"); each must be resolved or explicitly recorded, not silently carried.

---

## Handoff

- Structural fixes (B2.3, B5.x) → apply in `bicep-prune`.
- Reference/scope fixes (B3.x) → apply in `bicep-parameterize`.
- This skill is the **rule authority**; `bicep-validate` cites the rule number in
  `validate.json intentional_changes[].reason` when a delta is accepted as intentional.
