# Findings & known limitations — live AVM adopt test

Durable notes from a live end-to-end test of the AVM-adopt lane against a disposable
Azure test subscription. Environment-specific identifiers have been redacted.

## A. Operational / environment

1. **`ARM_*` env-var trap (most important).** A host with leftover `ARM_*` env vars
   (pointing at an unrelated service principal or the wrong tenant/sub) will silently
   hijack the `azurerm`/`azapi` providers. **Strip them in the same process before every
   `terraform` invocation:**
   ```powershell
   Get-ChildItem Env: | ? { $_.Name -like 'ARM_*' } | % { Remove-Item "Env:$($_.Name)" }
   ```
   `az` CLI ignores `ARM_*`, so `az` and `terraform` can disagree about identity — always
   verify with a stripped-env `terraform plan`, not `az account show`.

2. **Prefer interactive `az login` over `--use-device-code`.** When Conditional Access is
   enforced, device-code sign-in can succeed yet still lack authorization; interactive
   `az login --tenant <tenant-id>` is the reliable path.

3. **Scope to a single test resource group.** All identifiers in this evidence are
   redacted placeholders. The run targeted a disposable test subscription only.

4. **Shared subscription hygiene.** If other resource groups share the subscription, scope
   every action to the single test RG; never enumerate-and-act across the sub.

5. **Guardrail that held.** adopt/compose/validate is **read-only**; the fidelity gate is
   `terraform plan`, never `apply`/`az deployment create`. The only state-mutating ops the
   whole run were the initial fixture deploy and the final teardown.

## B. Azure / Terraform mechanics

6. **azapi import residuals are expected, not drift.** Importing an `azapi_resource` by bare
   ARM ID makes the provider (a) assign the *latest* api-version while the module `type`
   pins an older one (e.g. storage `@2026-04-01→@2025-06-01`, vnet `@2025-07-01→@2024-07-01`),
   (b) mark computed `output` unknown, (c) add provider-meta (`response_export_values`,
   `retry`, `timeouts`, `locks`), (d) flip `ignore_null_property`, (e) null out unmanaged
   optional body props. All surface as in-place `~` but mutate nothing on apply. Import
   blocks **cannot pin api-version**, so these are irreducible without forking the module.

7. **Plan-reading gotcha.** A `- tags = {…}` line can appear *inside* an azapi
   `output = {…} -> (known after apply)` computed block — that is NOT a real tag change.
   The real resource-level `tags` attribute is separate and was stable. Always check which
   block a diff line belongs to before calling it drift.

8. **Set-typed vars can't preserve order.** AVM keyvault types `secret_permissions` as
   `set(string)`, so any input order collapses to Terraform's sorted set; the imported live
   policy keeps creation order → permanent cosmetic reorder diff. Azure treats KV perms as a
   set, so it's a no-op. Not fixable via config.

9. **Some AVM modules ship internal orchestration resources.** opinsights 0.5.1 declares
   `time_sleep.wait_for_ampls_update` **unconditionally** (no count/for_each). It shows up as
   `add=1` in an import-only plan despite creating zero Azure infra. Therefore **no
   azapi-backed / helper-bearing adopt can ever hit a literal `add=0`.**

10. **`enable_telemetry = false` works.** It suppressed all `modtm_telemetry` / `random_uuid`
    create resources — the only residual `add` was the unrelated `time_sleep`.

## C. Plugin / product recommendations (for PR #2)

11. **Validate gate should classify, not just count.** The "import-only / no-op" success
    check needs an allowlist for (a) module-internal helpers (`time_sleep`, `null_resource`,
    telemetry) and (b) azapi import residuals. Otherwise the gate reports false fidelity
    misses on every realistic adopt.

12. **The high-value catches are secure-default divergences.** The two genuine issues this
    run found & fixed — KV `tags` omission and storage `local_user_enabled` (module secure
    default `false` vs live `true`) — are exactly what a faithful reconciliation exists to
    surface. This is the plugin's core value and it worked.

13. **Document the set-typed-permission reorder** so adopters don't chase a cosmetic diff.

## D. Result snapshot

Final plan: **`8 import · 1 add · 5 change · 0 destroy · 0 replace`**; 8/8 imports matched;
coverage 100% (4/4 types, 0 gaps). Verdict: **faithful adoption PASS**, all residuals benign
and enumerated. Full write-up: `live-test/REPORT.md`.

## E. PR #1 `azure-iac-skills` (export lane) — added after live test

14. **Export explosion is export-platform-wide, not TF-specific.** One Log Analytics workspace
    auto-materializes **676 built-in `workspaces/tables` + 39 default `workspaces/savedSearches`**.
    A naïve full-RG export of an 8-resource fixture returns **722** (`exportTerraform`) / **726**
    (`exportTemplate`) resources — the explosion reproduces identically on the ARM/Bicep lane.
    Mitigate symmetrically: `excludeTerraformResource:["azurerm_log_analytics_workspace_table_custom_log","azurerm_log_analytics_saved_search"]`
    (TF) / post-export filter of `workspaces/tables`+`workspaces/savedSearches` (Bicep).

15. **`exportTerraform` api-version bug.** Skill says `2025-09-01-preview` → **404**. Working
    version is **`2025-06-01-preview`**. `POST .../providers/Microsoft.AzureTerraform/exportTerraform`,
    LRO via `Azure-AsyncOperation` header.

16. **`exportTemplate` LRO mechanics.** `POST /resourceGroups/{rg}/exportTemplate?api-version=2021-04-01`,
    body `{resources:["*"], options:"SkipResourceNameParameterization"}` → `202` + `Location`
    header. **PowerShell returns that header as `String[]` — index `@($resp.Headers["Location"])[0]`.**
    Poll `GET` until `200`; body has `.template`. `SkipResourceNameParameterization` → literal
    names, **0 parameters** (no inputs needed for what-if).

17. **Export runs under a first-party Microsoft SP, not the user.** Control-plane read only →
    **cannot read data-plane**: KV secret value (**401**) and storage queue props/keys (**403**).
    TF drops both as orphaned imports (still `0 change`); ARM export captures the KV secret
    **shell only** (never the value — ARM never round-trips secret values).

18. **Bicep decompile vnet↔subnet cycle (BCP080).** Export declares the subnet BOTH inline
    (`vnet.properties.subnets`) AND as a standalone child → cyclic Bicep that won't build.
    **Fix: strip inline `properties.subnets` from the vnet before `az bicep decompile`.**

19. **what-if benign export-default Modifies.** Container `immutableStorageWithVersioning:{enabled:false}`
    and default sub-service empty `logging` show as Modify but are export defaults, not drift.
    Pruning them (+ implicit file/queue/table sub-services) → clean **8 NoChange**. Also:
    `2>&1` merges az/bicep WARNING lines into the JSON → slice from first `{` before `ConvertFrom-Json`.

20. **Export dispatch is a direct ARM control-plane REST call.** The export/harvest action
    calls the authenticated `management.azure.com` control-plane endpoints directly (here via
    `az rest` / raw `Invoke-WebRequest` + bearer token); any HTTP client holding an ARM token
    behaves identically. A remote ARM MCP server, when wired, serves only the read/query (ARG)
    and Bicep what-if operations it exposes — not export.

21. **PR #1 result snapshot.** TF: **`7 import · 0 add · 0 change · 0 destroy`** (cleaner than
    PR #2 — classic `azurerm`, no azapi residuals). Bicep: **`8 NoChange`** what-if. Verdict:
    **export PASS both lanes.** Full write-up: `live-test-pr1/REPORT.md`.
