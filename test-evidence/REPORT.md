# Live End-to-End Test Report — Vanilla AI baseline (PR #3, no skills)

> Control run: a plain Copilot agent with **no `azure-iac`/`azure-avm` skills loaded**,
> given only the goal ("convert this live Azure resource group to import-ready
> Terraform and Bicep") and live Azure access. Same tenant, same fixture shape,
> same fidelity gate as PR #1 / PR #2. Purpose: measure the skills' *differential*
> value against a competent-but-unguided baseline.

## 1. Verdict

**PASS (both lanes), with characterized residual friction.**

| Lane | Result | Gate (0 destroy / 0 replace) |
|------|--------|------------------------------|
| Terraform | `8 to import · 0 add · 0 change · 0 destroy` — **clean, first try** | ✅ |
| Bicep (what-if) | `9 NoChange · 2 Modify (benign) · 0 create/delete · 0 destroy` | ✅ |

For a **small, clean estate** the vanilla agent reproduces the infrastructure
faithfully. The skills' advantage here is **not** plan fidelity — it is
*discovery completeness, noise handling at scale, and systematic cleanup*
(§5), all of which the vanilla agent had to improvise by hand.

## 2. Scope

- Fresh fixture `rg-iacvanilla-stema-v9r4t` (eastus2), same 5-type / 8-resource
  shape as PR #1: RG, vnet (`10.43.0.0/16`) + subnet, StorageV2 + container,
  Key Vault + access policy + secret, Log Analytics workspace.
- Deployed live (`terraform apply` → 8 added), converted cold, gated, torn down.
- No skill prose, no session learnings reused — every fix below was
  (re)discovered from first principles / general Azure+Terraform competence.

## 3. Pipeline executed

### 3.1 Terraform lane — hand-authored from `az` discovery
1. `az group show` / `az network vnet show` / `az network vnet subnet list` /
   `az storage account show` / `az storage container show` /
   `az keyvault show` / `az keyvault secret show` / `az monitor log-analytics
   workspace show` — enumerated every resource **and its children** by hand.
2. Hand-wrote 8 `azurerm_*` resource blocks + 8 `import {}` blocks; provider
   with explicit `subscription_id`/`tenant_id`, plain `features {}`.
3. `terraform init` (azurerm 4.81) → `terraform plan` → **`8 import · 0 · 0 · 0`
   on the first attempt.** No iteration required.

### 3.2 Bicep lane — `az group export` → filter → decompile → what-if
1. `az group export --skip-all-params` → **726 resources / 411 KB** (see §5.2).
2. Filtered out `workspaces/tables` (676) + `workspaces/savedSearches` (39) →
   **11 meaningful resources**.
3. `bicep decompile` failed with **BCP080 cycle** (vnet ↔ subnet) → stripped
   inline `properties.subnets` from the vnet → decompile succeeded (§5.3).
4. `az deployment group what-if` → **9 NoChange + 2 benign Modify** (§5.5).

## 4. Coverage

All 8 live resources represented in the Terraform lane; all 11 export-visible
resources (incl. auto storage sub-services) represented in the Bicep lane.
No resource was dropped, orphaned, or auth-blocked — the human identity has the
data-plane access that PR #1's first-party service principal lacked, so the
KV secret imported cleanly here (vanilla TF captured **8** vs PR #1 export's 7).

## 5. Findings — friction a plain agent hits without the skills

### 5.1 Discovery gap — children invisible to `az resource list`
`az resource list -g <rg>` returns only the **4 top-level** resources (vnet,
storage, kv, law). Subnet, blob container, and KV secret are **not listed** —
the agent must *know* to drill into each parent with resource-specific `list`/
`show` calls. Miss one and the convert silently under-covers. **The skills
enumerate children systematically; the vanilla agent relies on the operator
remembering every child type.**

### 5.2 Log Analytics export explosion — ~90× noise
`az group export` returned **726 resources** for an 8-resource estate:
- **676** `Microsoft.OperationalInsights/workspaces/tables` (Azure built-in tables)
- **39** `Microsoft.OperationalInsights/workspaces/savedSearches` (built-in queries)
- ~11 actually-authored resources.

Raw, this is undeployable/unreviewable. A competent agent must **recognize these
as Azure-managed built-ins and filter them** — a judgment call the vanilla run
made ad hoc. **The skills filter this class automatically** (same explosion is
documented in PR #1 §5.2).

### 5.3 Bicep decompile — vnet↔subnet cycle (BCP080)
The exported vnet carries an inline `properties.subnets` array **and** a
standalone `subnets` child resource → `bicep decompile` emits **BCP080 "expression
is involved in a cycle."** Fix: strip inline `properties.subnets` before
decompiling (subnet survives as the child resource). A cold agent must diagnose
this from the error; the skills bake in the fix (PR #1 §5.4 hit the identical issue).

### 5.4 Secret values never export
`az group export` emits the KV secret with `attributes` but **no `value`** — and
`az keyvault secret show` requires **data-plane** access. Vanilla succeeded only
because the operator identity had `Get`/`List` on the vault. For the TF lane the
value was read directly; for the Bicep lane what-if ignores the secure value, so
the secret shows NoChange regardless. **No secret value was ever written to disk.**

### 5.5 Bicep what-if — 2 benign residual Modifies (left uncleaned)
The filtered export → what-if leaves **2 property-level Modifies**, both
`az group export` round-trip artifacts, neither touching a user-set value:
| Resource | Delta | Nature |
|----------|-------|--------|
| `blobServices/default/containers/data` | `+ properties.immutableStorageWithVersioning.enabled = false` | default no-op |
| `queueServices/default` | `- properties.logging` (server-managed analytics default) | default block the export omitted |

No `Create`/`Delete` of any resource, no destroy. The **skill-guided lane (PR #1)
runs a cleanup pass that eliminates exactly these to reach 8 NoChange**; the
vanilla run stops at "characterized and benign." A meticulous vanilla agent
*could* clean them too — but only by hand-editing decompiled Bicep it didn't write.

## 6. Secrets handling ✅
Secret value read via data-plane only for live discovery; never persisted to any
committed or scratch file. Bicep secret block carries no value. What-if masks it.

## 7. What the skills actually add (the differential)
For a tiny, clean estate, **vanilla ≈ skills on plan fidelity** — competent
hand-authoring from `az show` is inherently faithful. The skills' value shows up
on the axes a 1-RG control can't stress:
1. **Discovery completeness** — auto-enumerate every child type (§5.1) instead of
   relying on operator recall. Scales to estates with dozens of resource kinds.
2. **Noise handling at scale** — auto-filter the LAW 90× explosion (§5.2) and
   similar platform-managed classes, deterministically, every run.
3. **Baked-in known-issue fixes** — BCP080 (§5.3), export api-version bug
   (PR #1 §5.1), data-plane auth strategy (§5.4) — no rediscovery cost.
4. **Systematic residual cleanup** — drive the plan to *zero* residual, not just
   "benign" (§5.5).
5. **Repeatability / automation** — the skill pipeline is a script; the vanilla
   run is ~20 hand-issued `az` calls + manual JSON surgery, non-reproducible.
6. **AVM modularization (PR #2 only)** — a wholly separate value axis vanilla
   does not attempt: refactor into reusable Azure Verified Modules.

## 8. Comparison to PR #1 / PR #2

| Dimension | Vanilla (PR #3) | Export skills (PR #1) | AVM adopt (PR #2) |
|-----------|-----------------|-----------------------|-------------------|
| TF plan | `8 import·0·0·0` | `7 import·0·0·0` | `8 import·1 add·5 change·0 destroy` |
| Bicep what-if | `9 NoChange·2 benign Modify` | `8 NoChange` | n/a (TF-only) |
| Resource capture | 8/8 (data-plane access) | 7/8 (SP secret 401) | 8/8 |
| Discovery | manual per-child `az` | automated | automated |
| LAW 90× noise | filtered by hand | auto-filtered | auto-filtered |
| Residual cleanup | stops at "benign" | driven to 0 | 1 irreducible `time_sleep` |
| Output value | flat mirror | flat mirror | **modularized (reusable AVM)** |
| Reproducible | ✗ (hand-driven) | ✓ | ✓ |

**Read:** on a small estate vanilla is *competitive on fidelity* but *not
reproducible and not scalable*; the export skill's win is automation + a cleaner
final plan; the AVM skill's win is a fundamentally more valuable (modular) output.

## 9. Artifacts produced (this branch's `test-evidence/`)
- `convert-tf/{providers,main,imports}.tf` + `plan-output.txt` (`8·0·0·0`)
- `convert-bicep/filtered.bicep` + `whatif.json` + `whatif-summary.txt`
- `fixture/main.tf` (the deployed control fixture)
- this `REPORT.md`

## 10. Teardown
`terraform destroy` of the vanilla fixture + purge soft-deleted KV
`kv-iacv-v9r4t`; verify `az group exists` → false. (Executed at session close.)
