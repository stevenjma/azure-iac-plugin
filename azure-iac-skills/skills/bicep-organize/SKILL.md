---
name: bicep-organize
description: >
  Bicep-cleanup Phase 3.3 — reorganize a flat decompiled main.bicep into a maintainable structure:
  extract logical resource groupings into Bicep modules, order declarations conventionally, and
  wire module inputs/outputs. May report skipped when a single module is appropriate. Writes
  organize.json.
license: MIT
---

## Goal

Turn one flat `main.bicep` into a conventional, readable structure. This is the Bicep analog of
`cleanup-organize` (Terraform) — it improves maintainability without changing deployed intent.

## Preconditions

- Pass 3.2 (`bicep-prune`) reports `complete`.
- This pass is **allowed to skip** (with a reason) when the template is small/cohesive enough that
  a single file is the right design.

## Procedure

1. **Decide structure.** Group resources by lifecycle/domain (networking, storage, compute,
   identity, observability). If ≥2 cohesive groups of ≥3 resources exist, extract modules;
   otherwise skip with a reason.
2. **Extract modules.** For each group, create `modules/<domain>.bicep` and replace the resources
   in `main.bicep` with a `module <name> 'modules/<domain>.bicep' = { name: …, params: { … } }`.
   - Promote cross-module references to module `output`s consumed as module `params` — never
     reach across modules with literal IDs.
3. **Order conventionally** within each file: `targetScope` → `@description`'d params →
   `var`s → resources/modules → `output`s.
4. **Preserve intent.** Extraction must be behavior-neutral: the set of resources, their
   properties, names, and dependencies are unchanged — only their file location and reference
   style change.
5. **Compile check.** `az bicep build` on `main.bicep` after restructuring; fix module wiring
   until it compiles.

## Guardrails

- Behavior-neutral only. If a move would change a resource name, scope, or property, STOP.
- Do not create modules with a single resource unless it is a genuinely reusable unit.
- Keep secret parameters flowing as `@secure()` through module boundaries (coordinate with 3.4).

## Acceptance Criteria

Write `<workdir>/.cleanup/organize.json`:

```json
{
  "pass": "3.3-organize",
  "status": "complete",
  "modules_created": ["modules/network.bicep", "modules/storage.bicep"],
  "resources_moved": 11,
  "cross_module_wiring": [
    { "from": "network", "output": "subnetId", "to": "compute", "param": "subnetId" }
  ],
  "compiles": true
}
```

Or, when skipping:

```json
{ "pass": "3.3-organize", "status": "skipped", "reason": "7 resources, single cohesive domain; module split not warranted" }
```

Not complete unless `compiles == true` (when not skipped), the move was behavior-neutral, and
`checklist.json` pass `3.3-organize` reflects the outcome.
