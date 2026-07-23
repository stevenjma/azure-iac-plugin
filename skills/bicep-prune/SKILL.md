---
name: bicep-prune
description: >
  Use this skill during bicep-cleanup Phase 3.2 to remove decompile artifacts. Prune read-only
  properties, redundant dependencies, stale API versions, and unused generated parameters or
  variables without changing live Azure intent.
license: MIT
---

## Goal

Decompiled Bicep faithfully reproduces the ARM JSON — including properties the control plane
returns but that must NOT be set on write. Prune removes what should not be authored so that
`what-if` reports "no changes" for the right reasons.

## Preconditions

- Pass 3.1 (`bicep-parameterize`) reports `complete` in `checklist.json`.
- `constraint-map.json` is used if present to decide readOnly/computed authoritatively.

## What to prune

| Category | Signature | Action |
|---|---|---|
| Read-only / computed props | `id`, `provisioningState`, `etag`, `type` (on nested), `principalId` on system identity, timestamps, FQDNs the platform assigns | Remove from resource body (schema `readOnly: true`) |
| Redundant `dependsOn` | Explicit `dependsOn: [ … ]` where a symbolic reference already implies the dependency | Remove; rely on inferred dependency |
| Generated `param_*` / `var_*` bloat | Decompiler-emitted params/vars with machine names, unused after 3.1 | Delete if unreferenced; otherwise rename in 3.1 (return upstream if still referenced) |
| apiVersion sprawl / stale versions | Mixed or outdated `@YYYY-MM-DD` across same type | Normalize to a single current, valid apiVersion per type (verify against provider) |
| Empty/default noise | `properties: {}`, default-valued fields the platform would set anyway | Remove only when the constraint map confirms the default matches |
| Duplicated inline objects | Same object literal repeated | Hoist to a `var` (coordinate with organize if it crosses modules) |

## Procedure

1. For each resource, cross-check every property against the constraint map (or provider schema).
   Remove properties marked `readOnly`/`computed`.
2. Remove explicit `dependsOn` entries already implied by a symbolic reference; keep only genuine
   ordering dependencies the compiler cannot infer.
3. Delete unreferenced generated params/vars. If a generated name is still referenced, STOP and
   return to `bicep-parameterize` — do not silently delete a referenced symbol.
4. Normalize `apiVersion` per resource type to one current, valid version.
5. Run `az bicep build --stdout` after pruning to confirm it still compiles (do not treat this as
   the validate gate — it is a smoke check).

## Guardrails

- Never prune a property that is writable-and-set-to-a-non-default value — that changes intent.
- When unsure whether a property is readOnly, keep it and note it in `uncertain_kept` for
  `bicep-validate` to resolve via what-if.
- Do not delete a symbol that is still referenced.

## Acceptance Criteria

Write `<workdir>/.cleanup/prune.json`:

```json
{
  "pass": "3.2-prune",
  "status": "complete",
  "readonly_props_removed": 14,
  "redundant_dependson_removed": 6,
  "generated_symbols_deleted": 8,
  "apiversions_normalized": 5,
  "uncertain_kept": [
    { "resource": "storageAccount", "property": "primaryEndpoints", "reason": "unclear readOnly; defer to what-if" }
  ],
  "compiles": true
}
```

Not complete unless `compiles == true`, no referenced symbol was deleted, and `checklist.json`
pass `3.2-prune` is `complete`.
