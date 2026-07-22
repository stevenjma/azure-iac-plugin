---
name: brownfield-iac-export
description: >
  Export existing Azure infrastructure into Bicep OR Terraform code using the Azure
  control-plane export APIs (exportTemplate for Bicep, Microsoft.AzureTerraform/exportTerraform
  for Terraform), then hand off to the matching gated cleanup pipeline. Use when asked to
  "export", "brownfield", "adopt", "import from Azure", "reverse-engineer", "generate IaC for",
  or "exportTemplate"/"exportTerraform" Azure resources.
license: MIT
compatibility: >
  Requires az login authenticated. Terraform lane: terraform >= 1.5 for downstream lint/validate.
  Bicep lane: bicep CLI (az bicep) for decompile/build. ARM MCP server optional (governed
  control-plane upgrade); a direct authenticated ARM REST fallback (via `az rest`) works today
  with no MCP wired. No local aztfexport install required — Terraform export runs service-side.
---

## Purpose

This skill handles the **export side** of brownfield conversion for **both languages**:

- **What** to export (scope: resource / resource group / ARG query)
- **Which language** to target (Bicep or Terraform) — never defaulted silently
- **How** to export (which control-plane API, dispatched through the export-dispatch seam)
- **Post-export hygiene** (artifacts each export engine leaves behind)

After export completes it **invokes the matching cleanup orchestrator** on the raw output
(`terraform-cleanup` or `bicep-cleanup`) unless the user requested a quick/raw export. All
reference injection, parameter/variable extraction, secrets, pruning, organization, and
validation belong to those orchestrators and their sub-skills — not here.

## The core shift (vs. the legacy Terraform-only plugin)

| | Legacy | This skill |
|---|---|---|
| Engine | `aztfexport` local CLI | **Azure control-plane export APIs** (server-side) |
| Terraform | local aztfexport | `Microsoft.AzureTerraform/exportTerraform` (same aztfexport engine, run as a service) |
| Bicep | not supported | `resourceGroups/{rg}/exportTemplate` → ARM JSON → `bicep decompile` |
| Local prereqs | tf + aztfexport installed | az login; language CLI only for downstream lint/validate |

Because `exportTerraform` **is aztfexport-as-a-service** (identical engine, run server-side),
all downstream Terraform drift/translation rules in `azure-to-terraform-translation` apply 1:1.

## Separation of concerns

| Responsibility | This skill | cleanup orchestrator |
|---|:-:|:-:|
| Scoping (resource / RG / ARG query) | ✓ | |
| Language selection (bicep / terraform) | ✓ | |
| Provider selection (azurerm / azapi — TF only) | ✓ | |
| Export-dispatch (MCP tool / POST-action / ARM REST) | ✓ | |
| Bicep decompile of exported ARM JSON | ✓ | |
| Post-export hygiene (orphans, creds, decompile cruft) | ✓ | |
| References, params/variables, prune, organize, secrets, validate | | ✓ |

## Workflow

### Phase 0: Intake & scoping

1. **Existing IaC?** Does the user already have Bicep/Terraform for these resources and just
   want to adopt state / reconcile?
   - Terraform + adopt → export with import blocks only (Phase 1A).
   - Otherwise → continue.
2. **Scope** — ask for exactly one:
   - single resource ID,
   - resource group name,
   - ARG (Azure Resource Graph) `where` predicate (e.g. `type =~ "microsoft.network/virtualnetworks"`).
3. **Language** — ask **bicep** or **terraform**. ⚠️ Do NOT default silently. Present neutrally:
   - **Bicep** — Azure-native DSL, `exportTemplate` → decompile. Best when the team is Azure-only.
   - **Terraform** — HCL via `exportTerraform`; multi-cloud/HCP workflows, azurerm/azapi providers.
4. **Provider (Terraform only)** — ask **azurerm** or **azapi** (maps to `targetProvider`):
   - **azurerm** — curated schemas/validation; broad support. Unsupported types are skipped
     (surfaced in `skippedResources`).
   - **azapi** — every resource at any API version; bigger supported set; less curation.
   ⚠️ Do not mark either "Recommended"; present tradeoffs neutrally.
5. **Auth check** — run `az account show`. STOP with `az login` guidance if unauthenticated.
   Confirm the active subscription is the one that owns the scope; detect conflicting env vars
   (`ARM_CLIENT_SECRET` + a CLI login cookie) and warn.
6. **Quality target** — "quick export" (raw files, no cleanup) vs "platform-ready" (default,
   full gated cleanup + validate/fidelity gate).

Record the intake decisions to `<workdir>/.cleanup/intake.json` (verbatim language/mode quotes)
so the downstream validate gate can confirm scope selection (Gate C).

### Phase 1: Export execution — the export-dispatch seam

All export calls go through **one abstraction** so the pipeline never rewrites as ARM MCP matures.
Resolve in this **preference order** (first available wins):

1. **ARM MCP RP tool** — a first-class ARM MCP tool for the export action, if registered in the
   session (e.g. an `AzureTerraform`/export tool surfaced by the remote ARM MCP). Preferred when present.
2. **ARM MCP generic POST-action** — `list_available_actions → generate_resource_action_body →
   submit_resource_action` against the export endpoint, once that write path ships.
3. **Direct ARM REST via `az rest`** — the **works-today POC path**. `az rest` auto-attaches the
   caller's bearer token. This is a faithful stand-in for a remote MCP (a governed ARM-REST proxy).

Probe (1) and (2); if neither is available, use (3). Never fail the run solely because the MCP is
unwired — fall back to REST. See `reference/examples.md` for exact invocations.

#### Terraform lane — `exportTerraform` (LRO)

`POST https://management.azure.com/subscriptions/{subId}/providers/Microsoft.AzureTerraform/exportTerraform?api-version=2025-06-01-preview`

> **API version:** `Microsoft.AzureTerraform/exportTerraform` currently advertises exactly two
> versions — `2025-06-01-preview` (use this) and `2023-07-01-preview`. A previously-referenced
> `2025-09-01-preview` does **not** exist and returns `404 InvalidApiVersionParameter`. Confirm the
> live set at any time with:
> `az provider show -n Microsoft.AzureTerraform --query "resourceTypes[?resourceType=='exportTerraform'].apiVersions | [0]"`

Body by scope (`type` discriminator; add `"targetProvider":"azurerm"|"azapi"` from Phase 0.4):

| Scope | Body |
|---|---|
| Resource group | `{ "type":"ExportResourceGroup", "resourceGroupName":"<rg>" }` |
| Resource(s) | `{ "type":"ExportResource", "resourceIds":["<full-id>"] }` |
| ARG query | `{ "type":"ExportQuery", "query":"<where-predicate>" }` |

Useful optional fields: `namePattern` (default `res-`), `maskSensitive` (default true),
`fullProperties`, `excludeAzureResource`, `excludeTerraformResource`, `includeResourceGroup`.

**This is a long-running operation.** Handle the LRO: on `202`, poll the `Azure-AsyncOperation`
header URL until `status == "Succeeded"`. On success `properties` contains:
- `configuration` — the HCL → write to `main.tf`
- `import` — import blocks → write to `import.tf`
- `skippedResources` — resources not exportable (report in summary; azurerm users can retry azapi)
- `errors` — per-resource export errors

#### Bicep lane — `exportTemplate` → decompile

`POST https://management.azure.com/subscriptions/{subId}/resourceGroups/{rg}/exportTemplate?api-version=2021-04-01`

Body: `{ "resources":["*"], "options":"IncludeParameterDefaultValue,SkipResourceNameParameterization" }`
(`resources` may be specific resource IDs). Response `.template` is the ARM JSON.

> **Can be an LRO.** For a large / workspace-heavy RG, `exportTemplate` may return `202` with a
> `Location` header instead of an inline body — poll that URL until `200`, then read `.template`
> from the final response. (A RG containing a Log Analytics workspace routinely trips this — see the
> LAW export-explosion note in Phase 2.)

1. Write the returned template to `<workdir>/template.json`.
2. Decompile: `az bicep decompile --file <workdir>/template.json` → `<workdir>/main.bicep`.
3. Capture decompile warnings (decompilation is best-effort; some ARM constructs don't round-trip
   cleanly) — these are the primary cleanup targets for `bicep-cleanup`.

> Note: `exportTemplate` also accepts `"targetProvider":"terraform"` (the portal's preview
> Terraform export). We deliberately use the dedicated `Microsoft.AzureTerraform/exportTerraform`
> RP action for Terraform instead — it is the more capable, supported engine with import blocks,
> ARG/resource scoping, and skip reporting.

#### Phase 1A: Terraform import-blocks-only path (adopt existing code)

When the user already has Terraform and only wants to adopt state:
1. Export with the same call; keep the `import` output, discard `configuration`.
2. Return import blocks for the user to add to their existing `.tf`.
3. Generate `moved {}` blocks if resources are being reorganized.
4. Do NOT generate new resource code — the user's code is source of truth.
5. If validation is requested, invoke `cleanup-validate` directly (the only legitimate entry into
   validate outside the `terraform-cleanup` orchestrator). No cleanup-pipeline summary is produced.

### Phase 2: Post-export hygiene

Fix engine artifacts that would block downstream validation. **Do not** do full cleanup here.

**Terraform** (see `azure-to-terraform-translation` Rule 1.x for the full patterns):
1. **Orphaned import blocks** — an `import { to = <type>.<name> }` with no usable target. **Two
   distinct live-proven causes**, both must be swept:
   - **Skipped-resource orphan** — `<type>.<name>` has no matching `resource` block (the resource
     appeared only in `skippedResources`). Delete the import.
   - **Failed-import orphan** — the resource IS declared, but the export left a per-resource entry
     in `properties.errors[]` (an `ImportError`), so its `id` is missing/unusable. Root cause seen
     live: the server-side `Microsoft.AzureTerraform` **service identity** got `401/403` reading
     certain resources — it is a **distinct principal** from your `az` login, so RBAC it separately
     or re-export those IDs under user context. Delete or repair the affected import before plan;
     leaving it makes `terraform plan` fail with "Cannot import non-existent remote object".
   Cross-check `import.tf` against **both** `skippedResources` **and** `errors[]` — not just the
   set of emitted `resource` blocks.
   **Auto-remediation helper** (`reference/strip-orphan-imports.ps1`, live-proven on the export
   result): parses `properties.errors[]` (TF address is the token after `" as "` in each
   `ImportError` message) and the declared `resource "<type>" "<name>"` set from
   `properties.configuration`, then rebuilds `import.tf` dropping every `import{}` block that is
   either a **failed-import** (address in `errors[]`) or a **skipped-target** (address with no
   matching `resource{}` block). Dry-run by default; `-WriteChanges` to apply. On the live 9-block
   export it stripped exactly the 2 unreadable imports (`azurerm_key_vault_secret`,
   `azurerm_storage_account_queue_properties`) and kept the 7 good ones, so the first
   `terraform plan` is clean with no manual triage.
2. **Strip credentials from the provider block** — remove `client_id`, `client_secret`,
   `tenant_id`, `use_cli`, `use_oidc`, `use_msi`, default `environment`. Keep `features {}`.
   Extract `subscription_id` → `var.subscription_id` (ask; default to detected). Never hardcode.
3. **Empty-string enum attributes** → valid defaults (e.g. `public_network_access = "" → "Enabled"`).
4. **Report `skippedResources`** from the export result; cross-reference orphan removal.

**Bicep**:
1. **Decompile warnings triage** — collect `az bicep decompile` warnings; flag constructs that
   didn't round-trip (these become `bicep-cleanup` param/prune targets, not fixes here).
2. **Confirm it builds** — `az bicep build --file main.bicep` to a scratch path; a hard failure
   here means decompile produced invalid Bicep and must be triaged before cleanup handoff.
3. **Note hardcoded values** — literal subscription IDs / secrets / resource names that
   `bicep-cleanup` will parameterize (`@secure()` params, `param location`, etc.).
4. **LAW export-explosion filter (no exclude-param equivalent!)** — a Log Analytics workspace
   auto-materializes hundreds of `workspaces/tables` + `workspaces/savedSearches` into the template
   (live, reproduced across **two** independent deployments: **715 of 726 resources = 98.5% noise**
   — 676 `tables` + 39 `savedSearches` — collapsing to **11** real resources both times). **Asymmetry
   with the TF lane:** `exportTerraform` suppresses these at source via `excludeTerraformResource`, but
   `exportTemplate` has **no exclusion parameter** — you MUST post-export filter
   `Microsoft.OperationalInsights/workspaces/tables` and `.../savedSearches` out of `template.json`
   **before** decompile, or the tree is unusable.
5. **vnet inline-subnet strip (BCP080 cycle)** — decompiled virtual networks model subnets **both**
   inline (`properties.subnets`) **and** as separate child resources, which `az bicep build` rejects
   with a **BCP080 self-reference cycle**. Strip the inline `subnets:[…]` from the vnet body (keep
   the child `Microsoft.Network/virtualNetworks/subnets` resources) before handoff.

### Phase 3: Hand off to the matching cleanup orchestrator

```
Quality target == "quick export"?
  YES → deliver raw files + summary; stop.
  NO  → language == "terraform" → invoke terraform-cleanup with:
          - path to exported .tf, provider target (azurerm/azapi/mixed),
            import blocks, skippedResources (context)
        language == "bicep"     → invoke bicep-cleanup with:
          - path to main.bicep, template.json, decompile warnings
```

### Phase 4: Export summary

```
## Export Summary
- Scope:    [resource / resource group / ARG query]
- Target:   [id / rg-name / query]
- Language: Bicep | Terraform
- Provider: azurerm | azapi | n/a (bicep)
- Dispatch: ARM MCP RP tool | ARM MCP POST-action | direct ARM REST (az rest)

## Results
- ✓ Exported to [main.bicep | main.tf (+ import.tf)]
- ⚠️ N skipped / not round-tripped (see list)
- ✗ N export errors (see list)

## Next step
- [terraform-cleanup | bicep-cleanup orchestrator invoked — refinement in progress]
- [OR: Quick export complete — raw files delivered]
```

## Guardrails

| Rule | Enforcement |
|---|---|
| Always ask language (bicep/terraform) if not stated | Present choices; never silently default |
| Always ask provider (TF) if not stated | azurerm vs azapi; neutral tradeoffs |
| Never execute `terraform apply` / `az deployment ... create` | Hard stop — this is read/export only |
| Never install tools silently | STOP with install instructions |
| Export failure on one resource never blocks others | Continue; surface in `skippedResources`/summary |
| Never fabricate resource configurations | Only values from the export API or provider/ARM docs |
| Never hardcode `subscription_id` / secrets in provider or params | Extract to variables/secure params |
| Prefer MCP dispatch, fall back to ARM REST — never hard-fail on unwired MCP | export-dispatch seam order (1)→(2)→(3) |
| Clear conflicting auth env vars before export | Detect and warn |
| Always hand off to cleanup unless quick export | Automatic handoff to the language-matched orchestrator |

## Tools & endpoints used

| Mechanism | Phase | Purpose |
|---|---|---|
| ARM MCP RP export tool (if present) | 1 | Preferred governed export dispatch |
| ARM MCP generic POST-action (if shipped) | 1 | Governed export dispatch |
| `az rest` → `Microsoft.AzureTerraform/exportTerraform` | 1 | Terraform export (POC fallback, LRO) |
| `az rest` → `resourceGroups/{rg}/exportTemplate` | 1 | Bicep ARM-JSON export (POC fallback) |
| `az bicep decompile` / `az bicep build` | 1, 2 | ARM JSON → Bicep; build sanity check |
| `az account show` | 0 | Auth / subscription check |

## References

- `reference/examples.md` — exact `az rest` invocations, LRO polling, decompile, dispatch probe.
- `reference/strip-orphan-imports.ps1` — orphan-import auto-remediation (failed-import + skipped-target sweep).
- Sibling `terraform-cleanup` — gated Terraform post-export refinement.
- Sibling `bicep-cleanup` — gated Bicep post-decompile refinement.
- Sibling `azure-to-terraform-translation` — Terraform drift/translation rule library (Rule 1.x–9.x).
