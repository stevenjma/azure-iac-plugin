# Live End-to-End Test Report — `azure-avm-plugin` (PR #2)

**Artifact under test:** `azure-avm-plugin` skill bundle, PR #2 (`stevenjma-azure-avm-skills-pr2`)
**Lane:** Terraform · **Quality target:** faithful · **Mode:** full brownfield adopt
**Tenant:** TEST (`11111111-1111-1111-1111-111111111111`) · **Sub:** Terraform (`00000000`) · **RG:** `rg-avmtest-demo-20260721` (eastus2)
**Date:** live run this session · **Run by:** adopt→compose→validate pipeline executed by hand per the skill instructions

---

## 1. Verdict

**PASS — faithful adoption with fully-documented, benign residuals.**

The plugin-generated AVM Terraform + `import` blocks produce an **import-only plan with zero destroy and zero replace**, and all 8 resources import with matching addresses/IDs. Every remaining diff is either a non-infrastructure module helper or a well-understood provider import residual — none mutate live Azure state semantically.

Final plan:

```
Plan: 8 to import, 1 to add, 5 to change, 0 to destroy.
```

| Hard gate | Result |
|---|---|
| Destroy == 0 | ✅ PASS |
| Replace == 0 | ✅ PASS |
| All imports matched (8/8) | ✅ PASS |

| Soft gate | Result |
|---|---|
| add == 0 | ⚠️ add == 1 (module-internal `time_sleep`, not Azure infra — irreducible) |
| in-place change == 0 | ⚠️ 5 changes (1 cosmetic set-reorder + 4 azapi import residuals — irreducible & benign) |

---

## 2. Scope

Brownfield fixture (raw `azurerm`, deployed then adopted): 4 resource types, 8 resources total.

| # | Resource | Name |
|---|---|---|
| 1–2 | VNet + subnet | `vnet-avmtest-9d6lh` / `snet-app` (10.42.0.0/16, snet 10.42.1.0/24) |
| 3–4 | Storage account + container | `stavmt9d6lh` / `data` |
| 5–7 | Key Vault + access policy + secret | `kv-avmt-9d6lh` / guest policy / `demo-secret` |
| 8 | Log Analytics workspace | `law-avmtest-9d6lh` |

---

## 3. Pipeline executed

| Phase | Skill | Result |
|---|---|---|
| 0 | intake | ✅ 4 types catalogued → `.avm/intake.json` |
| 1.1–1.2 | discover + resolve coverage | ✅ 4/4 types mapped to AVM modules, **100% coverage, 0 gaps** → `.avm/coverage.json` |
| 1.3 | harvest live config | ✅ 6 oracle files (mgmt-plane bodies + container list + secret metadata) → `.avm/harvest/*.json` |
| 2 | gap + secret triage | ✅ 0 coverage gaps; 1 secret identified (`demo-secret`) |
| 3.1 | map | ✅ 4 modules + 8 import blocks; `terraform init` **pass** → `.avm/map.json` |
| 3.2 | inputs | ✅ all module variables wired, 0 unresolved refs → `.avm/inputs.json` |
| 3.3 | organize | ⏭️ skipped (≤6 modules) → `.avm/organize.json` |
| 3.4 | secrets | ✅ sensitive var + untracked tfvars + `.example` → `.avm/secrets.json` |
| 4 | validate | ✅ Gates A/B/D pass, C n/a; plan loop ×2 → `.avm/validate.json` |

**Module version pins (faithful, from coverage resolution):**
`avm-res-network-virtualnetwork` 0.19.0 · `avm-res-storage-storageaccount` 0.7.3 · `avm-res-keyvault-vault` 0.10.2 · `avm-res-operationalinsights-workspace` 0.5.1.

**Provider backing discovered (mixed):** vnet & storage modules use `azapi_resource`; keyvault & LAW use classic `azurerm_*`. This mix is the source of the two distinct residual classes below.

---

## 4. Coverage

**100% — 4 of 4 resource types resolved to public AVM modules, zero fallbacks, zero deferrals.** Every child (subnet, container, access policy, secret) folded into its parent module as a nested block and imported at the module's internal resource address.

---

## 5. Fidelity — residual analysis

### 5.1 Two genuine composition issues (found by plan #1, FIXED)

| Issue | Cause | Fix | Verified |
|---|---|---|---|
| KV `tags -> null` | keyvault module block omitted `tags` (vnet/storage/law had it) | added `tags = local.tags` | ✅ gone in plan #2 |
| storage `isLocalUserEnabled: true -> false` | module default `local_user_enabled = false` (secure default) vs live `true` | pinned `local_user_enabled = true` | ✅ gone in plan #2 |

These are the two diffs a faithful adopt *should* catch and reconcile — the reconciliation ledger (`.avm/reconciliation.json`) records both as `decision: pin`.

### 5.2 The single `add` (irreducible, not infrastructure)

`module.law.time_sleep.wait_for_ampls_update` — the opinsights module 0.5.1 declares this `hashicorp/time` resource **unconditionally** (`main.privatelinkscope.tf:97`, no `count`/`for_each`). It waits 30s and creates **zero Azure infrastructure**. A pure adopt cannot reach a literal `add=0` with this module version without forking the module (out of scope). **Not a fidelity failure.**

### 5.3 The five in-place `change`s (all benign)

| Resource | Class | Azure change? | Why |
|---|---|---|---|
| KV `access_policy["guest"]` | set-typed reorder | **No** | Module types `secret_permissions` as `set(string)` → sorts to `[Delete,Get,List,Purge,Recover,Set]`; live keeps creation order. Azure treats as a set → no-op reorder. Irreducible via config. |
| storage `azapi_resource.this` | azapi import residual | **No** | api-version drift `@2026-04-01→@2025-06-01`, computed `output → (known after apply)`, `ignore_null_property false→true`, provider-meta (`response_export_values`/`retry`/`timeouts`/`locks`). |
| storage container `azapi_resource.this` | azapi import residual | **No** | api-version drift, output refresh, provider-meta. |
| vnet `azapi_resource.vnet` | azapi import residual | **No** | api-version drift `@2025-07-01→@2024-07-01`, output refresh, unmanaged optional body props → null (incl. `subnets` — subnet is separately imported), provider-meta. |
| vnet subnet `azapi_resource.subnet[0]` | azapi import residual | **No** | api-version drift, output refresh, body nulls, provider-meta. |

**azapi import residuals explained once:** when an `azapi_resource` is imported by bare ARM ID, the provider assigns the resource `type` the *latest* api-version and marks computed `output` unknown; the module pins an older api-version and sets provider-meta blocks. These surface as in-place `~` diffs but are **metadata/computed refresh only** — on apply they re-read the resource at the pinned api-version with no Azure mutation.

---

## 6. Secrets handling ✅

- `demo-secret` value sourced from **sensitive variable** `kv_secret_demo_value`; no literal secret in config.
- Real value lives only in **untracked, gitignored** `secrets.auto.tfvars`; committed tree keeps only `secrets.auto.tfvars.example` placeholder.
- Secret imported by **versioned data-plane id** → imports **cleanly with no diff**.
- Value never printed to logs at any point.

---

## 7. Findings / recommendations for the plugin

1. **Import-only plans are not literally `add=0/change=0` for azapi-backed modules or modules with internal orchestration helpers.** The validate gate's "import-only/no-op" target should explicitly whitelist: (a) module-internal `time_sleep`/`null_resource`/telemetry helpers, and (b) azapi import residuals (api-version drift, computed `output`, `ignore_null_property`, provider-meta). Recommend the skill's validate pass classify these automatically rather than flag them as fidelity misses.
2. **Set-typed permission variables can't preserve creation order on import** (KV `secret_permissions`). Worth a documented note so adopters don't chase a cosmetic reorder.
3. **Secure-default divergences are the high-value catch.** The two real diffs (KV tags omission, storage local-user) validate that a faithful reconciliation genuinely protects against silent drift — this is the plugin's core value and it worked.
4. `enable_telemetry = false` correctly suppressed all `modtm_telemetry`/`random_uuid` create resources — the only `add` was the unrelated `time_sleep`.

---

## 8. Artifacts produced (captured in this `test-evidence/` folder)

```
live-test/adopt/
  providers.tf  main.tf  imports.tf  variables.tf  outputs.tf
  secrets.auto.tfvars.example   .gitignore
  secrets.auto.tfvars           (untracked, real value)
  plan2.out.txt                 (final fidelity evidence)
  .avm/
    intake.json  coverage.json  harvest/*.json         (Phase 0–1 oracles)
    checklist.json  map.json  inputs.json
    reconciliation.json  organize.json  secrets.json  validate.json  (Phase 3–4)
```

---

## 9. Teardown — COMPLETE

The deployed fixture (8 resources) was torn down after the run (`terraform destroy` on the fixture + purge of the soft-deleted Key Vault); the test resource group no longer exists.
