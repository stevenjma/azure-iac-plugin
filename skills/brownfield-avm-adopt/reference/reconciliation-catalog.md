# AVM brownfield reconciliation catalog (Round-1 live evidence)

Field-proven catalog of the AVM secure/opinionated defaults that systematically drift
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
"Override input" names are the ones proven on that lane in Round 1; where a lane's exact
input was not independently verified in this round it is marked *(verify against module
schema)* rather than guessed — do not fabricate an input name, read the pinned module's
`variables.tf` / `main.json` `parameters`.

| Live (brownfield) posture | AVM secure default | Terraform override input | Bicep override param |
|---|---|---|---|
| storage `Standard_LRS` | **`Standard_ZRS` — silent!** | `account_replication_type` / `account_sku_name` (PROVEN: defaults ZRS if omitted) | `skuName` |
| storage infra-encryption off | `requireInfrastructureEncryption = true` | *(verify against module schema)* | `requireInfrastructureEncryption: false` (PROVEN) |
| storage blob soft-delete off | blob `deleteRetentionPolicy` enabled / 6–7 d | *(verify against module schema)* | `blobServices.deleteRetentionPolicyEnabled: false` (PROVEN) |
| storage container soft-delete off | `containerDeleteRetentionPolicy` enabled / 7 d | *(verify against module schema)* | `blobServices.containerDeleteRetentionPolicyEnabled: false` (PROVEN) |
| LAW query-CMK off | `forceCmkForQuery = true` | *(verify against module schema)* | `forceCmkForQuery: false` (PROVEN) |
| KV access-policy model | AVM **RBAC-authorization** shape, name inverted | `enable_rbac_authorization` = **NOT** `legacy_access_policies_enabled` (PROVEN inversion) | `enableRbacAuthorization` |
| KV purge-protection off | AVM tends to enable | `enable_purge_protection` *(verify)* | `enablePurgeProtection: false` |
| subnet outbound on | `defaultOutboundAccess` off | `default_outbound_access_enabled = true` (PROVEN) | `subnets[].defaultOutboundAccess: true` (PROVEN) |
| subnet PE network policies | `Disabled` vs live `Enabled` | `private_endpoint_network_policies = "Disabled"` (PROVEN) | `subnets[].privateEndpointNetworkPolicies: 'Disabled'` (PROVEN) |
| network default `Allow` | `networkAcls` default-action `Deny` | `network_rules` / `network_acls` *(verify)* | `networkAcls.defaultAction: 'Allow'` (PROVEN) |
| public network access | AVM may disable | `public_network_access_enabled` *(verify)* | `publicNetworkAccess: 'Enabled'` |

**Rule:** treat this catalog as a checklist during reconciliation. For "faithful" quality
target every drift above must be closed with the harvested oracle value; for "posture
uplift" each *unclosed* drift must be logged as a deliberate `adopt` decision in
`reconciliation.json` (never left as unexplained plan/what-if churn).

**The `Standard_ZRS` trap is the dangerous one:** the Terraform storage module silently
defaults to zone-redundant replication. Omitting the input does not reproduce a `LRS`
brownfield account — it plans a resiliency/cost change. Always wire storage SKU verbatim
from the oracle; never rely on the module default.

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
> not a clean import: AVM's secure defaults systematically drift from brownfield reality,
> and **neither language lane can reach a true zero-diff** — Terraform leaves a phantom
> `time_sleep` add, Bicep leaves permanent cosmetic `Modify` noise on every AVM resource.
