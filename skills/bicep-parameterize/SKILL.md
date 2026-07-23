---
name: bicep-parameterize
description: >
  Use this skill only during bicep-cleanup Phase 3.1, or when the user explicitly asks to
  parameterize Bicep. Replace reusable hardcoded values, resource names, locations, tags, and scope
  identifiers with typed parameters and variables while preserving the exported configuration.
license: MIT
---

## Goal

Turn a decompiled, literal-heavy `main.bicep` into a parameterized template that is reusable
across environments and free of hardcoded identity/scope values.

## Preconditions

- `<workdir>/.cleanup/intake.json` and `checklist.json` exist (orchestrator ran Phase 1).
- This is pass 3.1 — it runs first, before prune/organize/secrets.

## Procedure

1. **Scan** `main.bicep` for hardcoded values:
   - Literal `/subscriptions/<guid>/…` resource IDs and bare subscription GUIDs.
   - Literal resource names repeated across resources (candidates for a `name`/prefix param).
   - Hardcoded `location` strings (`'eastus'`, etc.).
   - Inline tag maps.
   - Magic numbers/SKUs the user will want to vary (SKU tiers, capacity, retention days).
2. **Add mandatory parameters** (create if absent) with `@description`:
   - `param location string = resourceGroup().location`
   - `param resourceGroupName string = resourceGroup().name` (only if referenced; prefer the
     `resourceGroup()` function over a param where possible).
   - `param tags object = {}` — and apply `tags: tags` on taggable resources.
   - A naming parameter or prefix (`param namePrefix string`) when literal names repeat.
3. **Replace** literal subscription IDs with `subscription().subscriptionId` and literal RG
   references with `resourceGroup().name` / `resourceGroup().id` where semantically correct.
   Never leave a bare subscription GUID in the resource body.
4. **Type and describe** every parameter: use `@description('…')`, `@allowed([...])` for enums
   discovered in the constraint map, and sensible `@minValue`/`@maxValue`/`@minLength` where the
   schema constrains them. Do NOT add `@secure()` here — that is `bicep-secrets` (3.4).
5. **Promote computed cross-references**: where the decompiler emitted a literal ID that points at
   another resource in the same file, replace it with a symbolic reference (`resA.id`,
   `resA.properties.x`) and let Bicep infer `dependsOn`.

## Guardrails

- Do not invent parameters for values the user cannot reasonably supply — prefer ARM functions
  (`resourceGroup()`, `subscription()`, `uniqueString()`) over parameters for scope/identity.
- Do not parameterize `apiVersion` — that is pruned/normalized in 3.2, not parameterized.
- Secret-looking values (keys, connection strings, passwords) are flagged for 3.4, not
  parameterized as plain strings here — note them in `secrets_deferred`.

## Acceptance Criteria

Write `<workdir>/.cleanup/parameterize.json`:

```json
{
  "pass": "3.1-parameterize",
  "status": "complete",
  "parameters_added": ["location", "tags", "namePrefix"],
  "literals_replaced": { "subscription_ids": 3, "resource_group_refs": 2, "resource_names": 4 },
  "params_typed_with_description": 9,
  "secrets_deferred": ["storageAccountKey", "sqlAdminPassword"],
  "literal_ids_remaining_locations": []
}
```

Not complete unless: every mandatory parameter exists or is justified via an ARM function,
`literal_ids_remaining_locations` lists any intentional remaining literals (each must be
justifiable to `bicep-validate` Gate B), and `checklist.json` pass `3.1-parameterize` is set to
`complete`.
