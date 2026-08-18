# AVM brownfield reconciliation catalog (Round-1 live evidence)

Field-proven catalog of the AVM secure/opinionated defaults that sydemotically drift
from a real brownfield estate, and of the **irreducible residual** that neither language
lane can eliminate. Everything here was observed on a live run — shared fixture of 8
resources (Log Analytics workspace, Key Vault, virtual network + subnet, storage account
+ blob container) in a single resource group, `eastus2`, harvested through the export
oracle and driven to a real fidelity gate (`terraform plan` / `az deployment group what-if`).
See `../../../test-evidence/adopt/` (TF) and `../../../test-evidence/adopt-bicep/` (Bicep).

Consume this from the reconciliation passes (`terraform-avm-inputs` /
`bicep-avm-inputs`) and set validate-gate zero-diff expectations from the residual section.

## 1. Secure-default drift catalog

Every row is an AVM default that differs from typical brownfield reality and therefore
shows up in the fidelity gate unless the harvested oracle value is wired in explicitly.
**All input names below were read directly from the pinned module source** (Round-2
verification), not guessed — TF from the cached `variables*.tf` of `avm-res-storage-
storageaccount/azurerm` **0.7.3**, `avm-res-keyvault-vault/azurerm` **0.10.2**,
`avm-res-operationalinsights-workspace/azurerm` **0.5.1**,
`avm-res-network-virtualnetwork/azurerm` **0.19.0**; Bicep params proven live in Round 1.
Where a TF module default already matches brownfield, the row is marked **Bicep-only** — a
real finding, not an omission.

| Live (brownfield) posture | AVM secure default | Drifts on | Terraform input (verified name / default) | Bicep param |
|---|---|---|---|---|
| storage `Standard_LRS` | **`Standard_ZRS` — silent!** | **both** | `account_sku_name` (preferred; `account_replication_type` **[DEPRECATED]**, default `ZRS`) | `skuName` |
| storage infra-encryption off | `requireInfrastructureEncryption = true` | **Bicep-only** | `infrastructure_encryption_enabled` — TF default **`false`** (already matches) | `requireInfrastructureEncryption` |
| storage blob soft-delete off | blob `deleteRetentionPolicy` enabled | **Bicep-only** | `blob_properties.delete_retention_policy` — TF `blob_properties` default **`null`** ⇒ no blob-service managed unless opted in | `blobServices.deleteRetentionPolicyEnabled` |
| storage container soft-delete off | `containerDeleteRetentionPolicy` enabled | **Bicep-only** | `blob_properties.container_delete_retention_policy` — same (null ⇒ unmanaged) | `blobServices.containerDeleteRetentionPolicyEnabled` |
| LAW query-CMK off | `forceCmkForQuery = true` | **Bicep-only** | `log_analytics_workspace_cmk_for_query_forced` — TF default **`null`** (not forced) | `forceCmkForQuery` |
| storage public access on | disabled | **both** | `public_network_access_enabled` — TF default **`false`** (set `true` to match live) | `publicNetworkAccess` |
| storage/KV net default `Allow` | default-action `Deny` | **both** | `network_rules.default_action` (storage, default **`Deny`**) / `network_acls.default_action` (KV) | `networkAcls.defaultAction` |
| KV purge-protection off | AVM enables | **both** | `purge_protection_enabled` — TF default **`true`**; **irreversible once on**, must set `false` up front | `enablePurgeProtection` |
| KV access model | **RBAC-authorization**, name inverted | **both** | `legacy_access_policies_enabled` (no `enable_rbac_authorization` var **exists**; set `true` to reproduce legacy KV) | `enableRbacAuthorization` |
| subnet outbound on | `defaultOutboundAccess` off | **both** | `default_outbound_access_enabled = true` (PROVEN) | `subnets[].defaultOutboundAccess` |
| subnet PE network policies | `Disabled` vs live `Enabled` | **both** | `private_endpoint_network_policies = "Disabled"` (PROVEN) | `subnets[].privateEndpointNetworkPolicies` |

**The TF and Bicep AVM modules are not equally opinionated — verified from source.** Three
"secure defaults" the Bicep AVM modules bake in (infra-encryption, blob/container
soft-delete, forced query-CMK) are **not** applied by the pinned TF modules — their
variables default to `false` / `null` / unmanaged. So the secure-default drift *set is
language-dependent*: on the TF lane those four rows are non-events, on the Bicep lane they
are proven drifts needing explicit overrides. This is a second cross-lane asymmetry on top
of the irreducible-residual one in §2.

**Rule:** treat this catalog as a checklist during reconciliation. For "faithful" quality
target every drift marked for the current lane must be closed with the harvested oracle
value; for "posture uplift" each *unclosed* drift must be logged as a deliberate `adopt`
decision in `reconciliation.json` (never left as unexplained plan/what-if churn).

**The `Standard_ZRS` trap is the dangerous one:** the Terraform storage module silently
defaults `account_replication_type` to zone-redundant (`ZRS`), honoured whenever
`account_sku_name` is null. Omitting the SKU does not reproduce a `LRS` brownfield account —
it plans a resiliency/cost change. Always wire `account_sku_name` verbatim from the oracle
(e.g. `Standard_LRS`); never rely on the module default.

## 2. Irreducible residual — neither lane reaches true zero-diff

The Round-1 headline, proven **symmetric on both PR#2 lanes**: a brownfield AVM adopt
**cannot** converge to a clean no-op, no matter how completely the oracle is fed. The
validate gate must therefore assert "zero *real* drift", not "empty plan / all NoChange".

### Terraform (azapi + azurerm) residual — `test-evidence/adopt/p2tf-plan7.log`
Final gate: **6 import / 1 add / 4 change / 0 destroy**, zero real config drift.
- **`+1 add` — `module.<law>.time_sleep.wait_for_ampls_update`**: an **unconditional**
  synthetic AVM helper (no `count`/`for_each`), so it has no Azure counterpart to import.
  Guaranteed ≥1 phantom "to add" on every adopt. Never a destroy; never a real change.
- **`~4 change`** on the `azapi_resource` primaries (storage / vnet / container / subnet),
  all structural, none value-changing:
  - azapi null-normalization (`false`/`[]` → `null`) on `defaultToOAuthAuthentication`,
    `isHnsEnabled`, empty `serviceEndpoints`, etc.
  - api-version pin churn (module pins a different `@api-version` than live GET returned).
  - subnet `addressPrefix` (singular) → `addressPrefixes` (plural list) rename.
  - vnet inline-subnets stripped from the body (**dual-modeling**: subnets are separate
    child `azapi_resource`s, not inline).
- **Import wiring gotchas proven live:** 2 of 4 AVM primaries (vnet, storage) are
  `azapi_resource` and take `parent_id` = the RG ID and support `import{}`; the subnet
  submodule uses `count`, so its import address needs the `[0]` index
  (`module.<vnet>.module.subnet["snet-app"].azapi_resource.subnet[0]`).

### Bicep (AVM registry) residual — `test-evidence/adopt-bicep/whatif-final.json`
Final gate: **2 NoChange / 5 Modify**, zero real drift after 4 secure-default overrides.
- **Every AVM-authored resource stays `Modify`** — AVM writes explicit property values the
  ARM RP omits on a GET (e.g. LAW `forceCmkForQuery` written as effective `'False'`,
  storage `customDomain` emitted as an empty object, `largeFileSharesState: 'Disabled'`,
  blob explicit-false retention shapes, container read-only encryption-scope fields the RP
  deletes). Property-level what-if therefore **never** collapses to `NoChange` for them.
- **Only pure-ARM resources reach `NoChange`** — here `vnet` and `subnet`, which AVM
  authors with no opinionated extra properties. This is the **inverse of the TF asymmetry**:
  TF's noise is a phantom *add*, Bicep's is a permanent *modify* on the AVM resources.

### What the validate gate should assert
- **TF:** plan is import-only **except** a known unconditional `time_sleep` add and
  api-version / null-normalization cosmetic changes — every remaining line must map to a
  `reconciliation.json` `adopt` entry.
- **Bicep:** AVM resources are expected `Modify` (cosmetic); only pure-ARM resources are
  expected `NoChange`. Assert **no `Create`/`Delete` of a real resource** and that every
  `Modify` is either an override you chose or a documented AVM-authoring artifact.

## 3. One-line thesis (for the adoption summary / PR report)

> Adopting existing Azure infra as AVM is an **override-heavy, oracle-driven** exercise,
> not a clean import: AVM's secure defaults sydemotically drift from brownfield reality,
> and **neither language lane can reach a true zero-diff** — Terraform leaves a phantom
> `time_sleep` add, Bicep leaves permanent cosmetic `Modify` noise on every AVM resource.

## 4. Reusing the catalog as a drift filter (Round-3 live evidence)

The residual floor above (§1–2) is not just a validate-gate reference — it is the **subtraction
key** for recurring drift review. Because an AVM adopt never reaches true zero-diff, real
out-of-band drift **co-locates with the floor at the same resources**, so you cannot detect it by
watching counts. Round-3 proof: 3 control-plane drifts (storage `minimumTlsVersion`, LAW
`retentionInDays`, an added `costcenter` tag) were injected live; **both lanes caught 100%**, but:

- **Bicep — the `Modify` count did NOT move (5 → 5).** All 3 drifts landed inside resources that
  were *already* permanent `Modify`s (law, storage). Counting is useless here. You must diff the
  **delta-path set** (`delta[].path` per resource) against this catalog's documented floor paths;
  the 3 new paths (`minimumTlsVersion`, `retentionInDays`, `tags.costcenter`) are the real drift.
- **Terraform — mixed surfacing.** LAW `retention` surfaced cleanly as a **newly-changing
  resource** (`azurerm_log_analytics_workspace.this` was import-only at baseline, now carries a
  real change), but storage `min_tls` + `costcenter` **folded into** `module.<storage>.azapi_
  resource.this` — a resource *already* changing for body normalization. So "is this resource
  newly changing?" catches some drift and **misses folded drift**; you must also diff the
  attribute/body paths *inside* resources that the floor already lists as changing.

**Inverse asymmetry vs PR#1 (the headline):** PR#1's sanitized TF baseline is *true* zero-diff, so
its drift review needs **no subtraction**. PR#2 pays a **recurring floor-subtraction tax at every
drift review** — this catalog is what makes that subtraction possible.

**Drift-review procedure:**
1. Treat the frozen baseline plan/what-if as the floor (this catalog IS that floor).
2. Re-run the read-only check (`terraform plan` / `az deployment group what-if`). **Do not compare
   counts.**
3. Compute the delta-path set: Bicep = `delta[].path` per resource (drop `[NoEffect]`); TF =
   changing attributes/body paths per resource, **including inside already-changing `azapi_
   resource`s**.
4. Subtract the catalog's documented floor paths. Whatever remains is **real drift** — map it or
   fix it.
5. Confirm the floor paths themselves are unchanged (a moved floor path means the module default
   or api-version pin shifted, not estate drift).
