---
name: bicep-avm-map
description: >
  bicep-avm-compose Phase 3.1 — turn coverage.json into the Bicep module-call skeleton. Emits one
  `module` block per resolved AVM type (pinned `br/public:avm/res/...:<version>` source, symbolic
  name, empty params to be wired by 3.2) and a confirmed fallback stub per coverage gap. Writes map.json.
license: MIT
---

## Goal

Materialize the resolver's decision into a compilable Bicep skeleton: every in-scope type becomes
either an AVM `module` block (resolved) or a confirmed fallback (gap). No input values are wired
here — that is `bicep-avm-inputs` (3.2). This pass owns **structure and version pinning**, not config.

## Preconditions

- `<workdir>/.avm/coverage.json` exists (from `avm-module-resolver`) with `resolved[]` + `gaps[]`.
- `<workdir>/.avm/intake.json` and `checklist.json` exist (orchestrator ran Phase 1).
- Every `gap` has a confirmed `fallback` (`raw-resource` | `child-of-parent` | `defer`).
- This is pass 3.1 — it runs first, before inputs/organize/secrets.

## Procedure

1. **Emit a module block per `resolved` entry.** Use the pinned source string from `coverage.json`
   verbatim (never re-derive the version). Give each a stable symbolic name derived from the live
   resource name (kebab→camel), and a `name:` for the deployment:

   ```bicep
   module storageAccount 'br/public:avm/res/storage/storage-account:0.32.1' = {
     name: 'sa1-deploy'
     params: {
       // wired by bicep-avm-inputs (3.2)
     }
   }
   ```

   Leave `params: {}` (or only the required `name` if trivially known). Do NOT guess inputs.
2. **Preserve one module block per live resource instance**, not per type — if the scope has three
   storage accounts, emit three module blocks pointing at the same source, with distinct symbolic
   names. Record the symbolic-name ↔ live-resource-id mapping (3.2 and validate rely on it).
3. **Handle child types by fold, not by separate call.** If a resolved child (e.g.
   `vaults/secrets`) has an `Available` child module but its parent is also in scope, prefer marking
   it `fold-into-parent` so 3.2 wires it through the parent module's input array. Emit a standalone
   child-module block only when the parent is out of scope.
4. **Emit fallback stubs per `gap`** according to its confirmed `fallback`:
   - `raw-resource` → a plain `resource` block placeholder (a clearly-commented TODO the inputs
     pass fills from the oracle; keeps the tree honest about non-AVM coverage).
   - `child-of-parent` → note it will be folded into a parent module's inputs; no separate block.
   - `defer` → no block; list it in `map.json.deferred` so validate knows it was intentionally
     excluded (and the fidelity gate does not expect it).
5. **Do not add `targetScope`/params/vars** beyond the module skeleton — organization is 3.3.
6. **Confirm it parses** — `az bicep build --file main.bicep --stdout` may legitimately fail on
   missing required params at this stage; instead run a lint that tolerates empty params, or defer
   the compile check to after 3.2. Record whether a parse was attempted.

## Guardrails

- Never re-derive a module name or version — read both from `coverage.json`. Irregular naming
  (`DBforPostgreSQL` → `db-for-postgre-sql`) makes computed names wrong.
- Never invent a module for a gap. A gap without a confirmed fallback blocks the pass.
- Never point two different types at the same module source. One resolved type → one module name.
- Prefer parent-module input folding over standalone child-module calls (AVM best practice).

## BEFORE (coverage.json excerpt)

```json
{ "resolved": [ { "type": "Microsoft.Storage/storageAccounts",
    "source": "br/public:avm/res/storage/storage-account:0.32.1", "status": "Available" } ],
  "gaps": [ { "type": "Microsoft.Foo/bars", "status": "absent", "fallback": "raw-resource" } ] }
```

## AFTER (main.bicep skeleton)

```bicep
module storageAccount 'br/public:avm/res/storage/storage-account:0.32.1' = {
  name: 'sa1-deploy'
  params: {}   // 3.2 wires from .avm/harvest/sa1.json
}

// GAP: Microsoft.Foo/bars has no AVM module (fallback: raw-resource). 3.2 fills from oracle.
// resource fooBar 'Microsoft.Foo/bars@2023-01-01' = { ... }
```

## Acceptance Criteria

Write `<workdir>/.avm/map.json`:

```json
{
  "pass": "3.1-map",
  "status": "complete",
  "modules_emitted": [
    { "symbol": "storageAccount", "type": "Microsoft.Storage/storageAccounts",
      "source": "br/public:avm/res/storage/storage-account:0.32.1", "liveId": "/subscriptions/…/sa1" }
  ],
  "folded_children": [],
  "fallbacks": [ { "type": "Microsoft.Foo/bars", "fallback": "raw-resource" } ],
  "deferred": [],
  "version_pins_from_coverage": true
}
```

Not complete unless: every `resolved` type has a module block with a pinned source, every `gap` is
represented by its confirmed fallback (or listed in `deferred`), `version_pins_from_coverage` is
true, no module version was re-derived, and `checklist.json` pass `3.1-map` is `complete`.

## Non-goals

- Wiring input values (3.2). Organizing into files (3.3). Securing secrets (3.4). Resolving
  coverage or versions (that was `avm-module-resolver`).
