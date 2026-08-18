---
name: avm-module-resolver
description: >
  Core engine for AVM adoption — resolve an Azure resource type (Microsoft.X/Y) to its Azure
  Verified Module: the language-specific source string (br/public:avm/res/... for Bicep,
  Azure/avm-res-*/azurerm for Terraform), the module status (Available / Orphaned / Proposed /
  none), a pinned version, and a coverage/gap decision. Use when asked "which AVM module maps to
  this?", to build the type→module map, or as the map step of a compose orchestrator.
license: MIT
compatibility: >
  Reads the public AVM module indexes (https://aka.ms/avm) — the machine-readable CSVs are the
  join tables. Version resolution needs egress to mcr.microsoft.com (Bicep) and the Terraform
  Registry. Works offline against the bundled reference/module-index.md for the common types, but
  authoritative resolution should refresh from the live index. Uses https://aka.ms/avm/llms as a
  compact documentation table of contents when supporting AVM guidance is needed.
---

## Goal

Turn each discovered live resource type into a **resolution record**: the AVM module that owns that
type for the chosen language, whether that module is usable, and the exact version to pin — or an
explicit **gap** with a fallback. This is the join between "what is deployed" (discovery + harvest)
and "what module call to emit" (compose). It is the single source of module truth for both language
lanes; the `-map` sub-skills are thin wrappers that call this engine per resource.

## The join key

Every AVM resource module is indexed by its ARM type, split into two columns:

```
ProviderNamespace  +  ResourceType    →   the ARM type
Microsoft.Storage  +  storageAccounts →   Microsoft.Storage/storageAccounts
```

Discovery (ARG `type` field, or the `type` in the export/harvest bag) gives you exactly this ARM
type. Match it **case-insensitively** against the index to find the module row. Do not attempt to
derive module names by string-munging the type — the mapping is curated and irregular (see the
naming notes below); always look it up.

## Preconditions

- The resource list to resolve (from `brownfield-avm-adopt` discovery) — each entry has at least
  `{ id, type }`, ideally the harvested property bag too.
- The chosen **language** (bicep | terraform) — resolution differs per language (different source
  strings, and a type can be Available in one language and only Proposed in the other).
- Access to the AVM index: prefer refreshing the live CSVs (see `reference/version-resolution.md`);
  fall back to the bundled `reference/module-index.md`.

## Retrieval budget

1. Fetch only the selected language's resource-module CSV and cache it for the run.
2. Resolve each distinct ARM type once; reuse the result for every resource of that type.
3. If the resolution needs AVM guidance beyond the structured feeds, fetch
   `https://aka.ms/avm/llms` once and follow only the relevant source Markdown link.
4. Fetch version metadata only for modules that resolved as `Available` or `Orphaned`.
5. Fetch a module interface only after resolution, directly from its `RepoURL`; never scan the full
   AVM documentation site or module repository.

The LLM index is a token-efficient navigation aid, not evidence for module metadata.

## Procedure

For each resource type in scope (dedupe first — resolve each distinct type once):

1. **Normalize the type.** Lowercase both sides; strip any trailing instance segments. For a
   **child** type (e.g. `Microsoft.Storage/storageAccounts/blobServices/containers`) keep the full
   nested type — the index has rows for child modules too.

2. **Look up the row** in the language's index (`BicepResourceModules.csv` /
   `TerraformResourceModules.csv`, mirrored in `reference/module-index.md`). Read:
   - `ModuleName` — e.g. `avm/res/storage/storage-account` (Bicep) /
     `avm-res-storage-storageaccount` (Terraform).
   - `ModuleStatus` — `Available` 🟢 / `Orphaned` 🟡 / `Proposed` ⚪ / `Deprecated` 🔴 / (absent).
   - `PublicRegistryReference` — the source-string template (version placeholder `X.Y.Z` for Bicep).
   - `RepoURL` — provenance for the input schema.

3. **Decide usability** by status:
   - `Available` / `Orphaned` → **usable**. (Orphaned = published but unowned; still consumable —
     flag it so the user knows maintenance may lag.)
   - `Proposed` → **not yet published** → this is a **gap**. Do not invent a source string; a
     `Proposed` module cannot be restored/`init`-ed.
   - `Deprecated` → **gap**; note the replacement if the index lists one.
   - No row → **gap** (no AVM module for this type).

4. **Prefer parent modules over child modules.** If a child type's parent is also in scope and has
   a module, resolve the child as a **configuration of the parent module's inputs**, not a separate
   child-module call (e.g. a blob container becomes an entry in the storage-account module's
   `blobServices`/`containers` input, not a standalone `.../blob-service/container` call). Only emit
   a dedicated child-module call when the child is in scope but its parent is not. Record the choice.

5. **Resolve the version** (never float `latest`) per `reference/version-resolution.md`:
   - Bicep → newest stable tag from `https://mcr.microsoft.com/v2/bicep/avm/res/<ns>/<type>/tags/list`.
   - Terraform → newest stable version from the Terraform Registry for `Azure/<module>/azurerm`.
   - Substitute into the source string: Bicep `br/public:avm/res/<ns>/<type>:<ver>`; Terraform
     `source = "Azure/<module>/azurerm"` + `version = "<ver>"`.

6. **On a gap, choose a fallback** and record its `reason`:
   - **raw-resource** — emit a plain `resource` block for that one type (azurerm resource / Bicep
     `resource`), harvested from the oracle. The composition stays valid; only that type is un-modularized.
   - **child-of-parent** — if only a child type lacks a module but the parent has one, fold it into
     the parent module inputs (often removes the gap entirely).
   - **defer** — if the type is `Proposed`, note the upstream module so the user can revisit; still
     emit raw-resource now so the deployment is complete.
   Never silently drop a resource, and never emit a module reference for a non-`Available`/`Orphaned` module.

7. **Write the coverage artifact** (see Acceptance Criteria).

## Naming notes (why you must look up, not compute)

- **Bicep** kebab-cases each segment and preserves parent/child with slashes:
  `Microsoft.DBforPostgreSQL/flexibleServers` → `avm/res/db-for-postgre-sql/flexible-server`.
  The provider→segment transform is irregular (`DBforPostgreSQL` → `db-for-postgre-sql`).
- **Terraform** flattens to a single hyphenated module id with no slashes:
  `avm-res-db-for-postgre-sql-flexible-server` is **not** how it's named — it is
  `avm-res-<providerlower>-<typelower>` with provider/type joined, e.g.
  `avm-res-databricks-workspace`, `avm-res-operationalinsights-workspace`. Read the exact
  `ModuleName` from the index.
- **Coverage differs by language.** Bicep has far more published resource modules than Terraform
  today; several types are `Available` for Bicep but only `Proposed` for Terraform (e.g. Synapse
  workspace). Always resolve against the chosen language's index, never assume symmetry.
- **Parse the CSV properly** (quoted fields). `AlternativeNames` frequently contains commas, so a
  naive split corrupts columns — use a real CSV reader or the curated `reference/module-index.md`.

## Acceptance Criteria (mandatory)

Write `<workdir>/.avm/coverage.json`:

```json
{
  "pass": "resolve",
  "status": "complete",
  "language": "bicep",
  "index_source": "https://aka.ms/avm (BicepResourceModules.csv @ 2025-xx-xx)",
  "resolved": [
    {
      "type": "Microsoft.Storage/storageAccounts",
      "module": "avm/res/storage/storage-account",
      "status": "Available",
      "source": "br/public:avm/res/storage/storage-account:0.14.3",
      "version_source": "mcr:tags/list"
    },
    {
      "type": "Microsoft.Storage/storageAccounts/blobServices/containers",
      "module": "avm/res/storage/storage-account (via blobServices input)",
      "status": "Available",
      "resolution": "child-of-parent"
    }
  ],
  "gaps": [
    { "type": "Microsoft.Foo/bars", "reason": "no AVM module for type", "fallback": "raw-resource" },
    { "type": "Microsoft.Synapse/workspaces", "reason": "Proposed for terraform, not published", "fallback": "raw-resource", "defer_to": "Azure/avm-res-synapse-workspace/azurerm" }
  ],
  "coverage": { "types_total": 8, "types_modularized": 6, "types_fallback": 2, "percent": 75.0 }
}
```

The pass is **not complete** unless:
- Every distinct in-scope type appears exactly once in `resolved` or `gaps`.
- No entry in `resolved` has `status` outside `{ "Available", "Orphaned" }`.
- Every `resolved` module reference is version-pinned (no `latest`, no `X.Y.Z` placeholder).
- `coverage.percent` is computed from `types_modularized / types_total`.

## Guardrails

| Rule | Enforcement |
|---|---|
| Never emit a source string for a `Proposed`/`Deprecated`/absent module | It cannot restore/`init`; route to `gaps` |
| Never float `latest` | Pin an explicit version resolved from MCR / Registry |
| Never compute a module name by string transform | Look it up in the index; the mapping is curated |
| Resolve against the chosen language's index only | Coverage is asymmetric between Bicep and Terraform |
| Prefer parent-module inputs over standalone child-module calls | Fewer calls, matches AVM composition guidance |
| Never silently drop an un-mappable resource | Record a gap + fallback with a reason |

## Non-goals

- Does not wire input values — that is `-inputs` (this only names the module + version + schema pointer).
- Does not decide adopt-vs-pin for defaults — that is reconciliation in `-inputs`.
- Does not fetch the full input schema field-by-field — it points at `RepoURL`; `-inputs` reads it.

## References

- `reference/module-index.md` — the join table: common ARM types → Bicep & Terraform module names + status.
- `reference/version-resolution.md` — how to pin versions from MCR (Bicep) and the Terraform Registry.
- AVM documentation index for LLMs: **https://aka.ms/avm/llms**.
- Authoritative live index: **https://aka.ms/avm** (Bicep/Terraform Resource Module CSVs).
