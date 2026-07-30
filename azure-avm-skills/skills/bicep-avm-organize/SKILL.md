---
name: bicep-avm-organize
description: >
  bicep-avm-compose Phase 3.3 — structure the composed AVM Bicep for readability and reuse: group
  module blocks logically, extract shared params/vars, and decide whether a single file or a
  multi-file layout is warranted. May report skipped when a single file is appropriate. Writes organize.json.
license: MIT
---

## Goal

Make the AVM composition idiomatic and navigable without changing what it deploys. Because AVM
modules already encapsulate per-resource complexity, the organizing job here is **lighter** than
raw-resource cleanup — it is mostly grouping, shared-param extraction, and dependency clarity, not
decomposition of resource bodies.

## Preconditions

- `inputs.json` (3.2) reports `complete`; modules are wired.
- `map.json` symbol↔liveId mapping is available.

## Procedure

1. **Add file-level scaffolding**: `targetScope` (default `resourceGroup`), a top `@description`
   header, and mandatory shared params (`param location string = resourceGroup().location`,
   `param tags object = {}`) applied to every module's `tags`/`location` input where the module
   accepts them.
2. **Group modules by tier/domain** with comment banners (networking, data, compute, identity,
   observability) so the file reads top-to-bottom in dependency order. AVM modules infer
   `dependsOn` from symbolic output references — verify those references exist rather than adding
   explicit `dependsOn`.
3. **Extract genuinely shared values** into `var`/`param` (naming prefix, common SKU, log-analytics
   workspace resourceId consumed by many modules). Do not over-parameterize per-module inputs that
   the oracle already pinned.
4. **Decide layout:**
   - **Single file** (`main.bicep`) — default for small/medium scopes. Report `skipped` with a
     reason if no split is warranted (this is a legitimate, common outcome).
   - **Multi-file** — for large scopes, split by domain into `modules/<domain>.bicep` wrappers that
     themselves call AVM modules, wired from `main.bicep`. Keep the pinned AVM sources; do not
     inline module internals.
5. **Surface outputs** the operator will need (resource IDs, endpoints) as top-level `output`
   statements sourced from module outputs — never from secure inputs.
6. **Recompile** — `az bicep build --file main.bicep --stdout` must still succeed (or fail only on
   not-yet-supplied secure params, which 3.4 handles).

## Guardrails

- Never change a wired input value or a reconciliation decision — organizing is behavior-preserving.
- Never inline or fork an AVM module's internals to "reorganize" — keep the `br/public:` reference.
- Never emit a secure input as an `output`.
- Prefer symbolic output references over `dependsOn`; only add explicit `dependsOn` when no data
  edge exists.

## Acceptance Criteria

Write `<workdir>/.avm/organize.json`:

```json
{
  "pass": "3.3-organize",
  "status": "complete",
  "layout": "single-file",
  "groups": ["identity", "networking", "data", "compute", "observability"],
  "shared_extracted": ["location", "tags", "namePrefix", "lawResourceId"],
  "outputs_surfaced": ["storageAccountResourceId", "keyVaultUri"],
  "recompiled": "pass"
}
```

Or, when no restructuring is warranted:

```json
{ "pass": "3.3-organize", "status": "skipped", "reason": "single logical file; split not warranted" }
```

Not complete (or validly skipped) unless: input values are unchanged, the file still compiles (or
fails only on pending secure params), no secure output was emitted, and `checklist.json` pass
`3.3-organize` is `complete` or `skipped` with a reason.

## Non-goals

- Wiring inputs (3.2). Securing secrets (3.4). What-if (4). Module/version selection (resolver/3.1).
