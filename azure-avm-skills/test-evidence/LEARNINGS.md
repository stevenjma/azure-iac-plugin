# Learnings — BAMI live AVM adopt test (carry forward)

Durable notes from the live end-to-end test of `azure-avm-plugin` PR #2 in the BAMI tenant.
Kept in session `files/` so they survive checkpoints.

## A. Operational / environment (Windows + BAMI)

1. **`ARM_*` env-var trap (most important).** This Windows box has persistent leftover
   `ARM_*` env vars pointing at an unrelated service principal / wrong tenant+sub. They
   silently hijack the `azurerm`/`azapi` providers. **Every `terraform` invocation must
   strip them in the same process first:**
   ```powershell
   Get-ChildItem Env: | ? { $_.Name -like 'ARM_*' } | % { Remove-Item "Env:$($_.Name)" }
   ```
   `az` CLI ignores `ARM_*`, so `az` and `terraform` can disagree about identity — always
   verify with a stripped-env `terraform plan`, not `az account show`.

2. **Never `az login --use-device-code`.** Conditional Access blocks device-code in this
   tenant ("sign-in successful but you don't have permission"). Use normal interactive
   `az login --tenant 4f00b3b6-2940-4f2c-b037-94637c180d30`. If `az` breaks, ask the user
   to re-login rather than retrying device-code.

3. **BAMI coordinates.** Tenant `4f00b3b6-2940-4f2c-b037-94637c180d30`, sub **"Terraform"**
   `e4b62b3b-7634-4972-8bbe-5d7197159f26`; `stema@microsoft.com` is a B2B **guest Owner**
   (guest object id `4b645026-a054-4404-8f64-62929c02052c`). Access to the tenant/sub took
   several tries and a "new BAMI tenant" hand-off before it worked.

4. **Shared subscription.** Other people's RGs live here. Scope every action to the single
   test RG; never enumerate-and-act across the sub.

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

20. **Dispatch fell to tier-3 REST.** ARM MCP servers aren't wired for export
    (`azure-mcp-azureterraform` = docs/`aztfexport`-command gen; `azure-mcp-arm` = ARG+deployments),
    so both lanes used raw `Invoke-WebRequest`+bearer, exactly as the skill's fallback specifies.

21. **PR #1 result snapshot.** TF: **`7 import · 0 add · 0 change · 0 destroy`** (cleaner than
    PR #2 — classic `azurerm`, no azapi residuals). Bicep: **`8 NoChange`** what-if. Verdict:
    **export PASS both lanes.** Full write-up: `live-test-pr1/REPORT.md`.
