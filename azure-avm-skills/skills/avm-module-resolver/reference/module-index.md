# AVM module index — the join table

The resolver's authority is the **Azure Verified Modules module index** at **https://aka.ms/avm**.
That page renders a catalog, but the load-bearing artifacts are two machine-readable CSVs — the
join tables between an ARM resource type and its AVM module.

For supporting AVM documentation, fetch **https://aka.ms/avm/llms** once. It is a compact table of
contents containing direct source-Markdown links. Follow only the links needed for the current
decision; do not crawl the rendered site or documentation repository. The LLM index is navigation
only—the CSVs below remain authoritative for module names and statuses.

## Source CSVs

| Language | URL |
|---|---|
| Bicep | `https://raw.githubusercontent.com/Azure/Azure-Verified-Modules/main/docs/static/module-indexes/BicepResourceModules.csv` |
| Terraform | `https://raw.githubusercontent.com/Azure/Azure-Verified-Modules/main/docs/static/module-indexes/TerraformResourceModules.csv` |

Fetch only the CSV for the chosen language, cache it for the run, and **parse as real CSV** (fields
are quoted and `AlternativeNames` contains commas — a naive `split(',')` corrupts the columns):

```powershell
$ProgressPreference = 'SilentlyContinue'
$base = 'https://raw.githubusercontent.com/Azure/Azure-Verified-Modules/main/docs/static/module-indexes'
$file = if ($language -eq 'bicep') { 'BicepResourceModules.csv' } else { 'TerraformResourceModules.csv' }
$index = (Invoke-WebRequest -UseBasicParsing "$base/$file").Content | ConvertFrom-Csv
```

Columns used by the resolver: `ProviderNamespace`, `ResourceType`, `ModuleName`, `ModuleStatus`,
`PublicRegistryReference`, `RepoURL`. (Bicep also carries `TelemetryIdPrefix`.)

## Join algorithm

```
arm_type            = discovery/harvest "type"     e.g. Microsoft.Storage/storageAccounts
(ns, rt)            = arm_type.split('/', 1)         → ("Microsoft.Storage", "storageAccounts")
row                 = index.first(r => r.ProviderNamespace ~= ns  &&  r.ResourceType ~= rt)   # case-insensitive
module, status      = row.ModuleName, row.ModuleStatus
```

For **child types**, keep the full nested `ResourceType` (e.g. `vaults/secrets`,
`storageAccounts/blobServices/containers`) — the index has child rows too.

## Status semantics

| ModuleStatus | Glyph | Usable? | Resolver behavior |
|---|---|---|---|
| `Available` | 🟢 | yes | resolve → module call, pin version |
| `Orphaned` | 🟡 | yes | resolve → module call, **flag** unmaintained ownership |
| `Proposed` | ⚪ | no | **gap** — not published, cannot restore/`init` → fallback |
| `Deprecated` | 🔴 | no | **gap** — note replacement if listed → fallback |
| (no row) | — | no | **gap** — no AVM module for this type → fallback |

`Proposed`/`Deprecated`/absent are never turned into a source string — they route to `coverage.json`
`gaps` with a `fallback` (`raw-resource`, `child-of-parent`, or `defer`).

## Naming transforms (read, don't compute)

- **Bicep `ModuleName`** = `avm/res/<provider-kebab>/<type-kebab>`, slashes preserved for
  parent/child (`avm/res/key-vault/vault/secret`). Consumed as
  `br/public:<ModuleName>:<version>`. Source repo: `RepoURL` under `Azure/bicep-registry-modules`.
- **Terraform `ModuleName`** = `avm-res-<providerlower><typelower>` — provider and type joined,
  **no** slashes, sub-resources folded into inputs (`avm-res-keyvault-vault`). Consumed as
  `source = "Azure/<ModuleName>/azurerm"` + `version = "<version>"`. Source repo:
  `Azure/terraform-azurerm-<ModuleName>`.
- The provider→segment transform is irregular (`DBforPostgreSQL` → Bicep `db-for-postgre-sql`,
  Terraform `dbforpostgresql`). **Always read `ModuleName` from the index; never string-munge.**

## Curated map — common brownfield types (verified against the live index)

Status shown as `Bicep / Terraform`. Verified via proper CSV parse; treat as a fast path and
re-confirm from the live CSV for authoritative runs (statuses/versions move).

| ARM type | Bicep module | Terraform module | Status (B / T) |
|---|---|---|---|
| `Microsoft.Storage/storageAccounts` | `avm/res/storage/storage-account` | `avm-res-storage-storageaccount` | 🟢 / 🟢 |
| `Microsoft.KeyVault/vaults` | `avm/res/key-vault/vault` | `avm-res-keyvault-vault` | 🟢 / 🟢 |
| `Microsoft.KeyVault/vaults/secrets` | `avm/res/key-vault/vault/secret` | *(fold into vault inputs)* | 🟢 / — |
| `Microsoft.Network/virtualNetworks` | `avm/res/network/virtual-network` | `avm-res-network-virtualnetwork` | 🟢 / 🟢 |
| `Microsoft.Network/networkSecurityGroups` | `avm/res/network/network-security-group` | `avm-res-network-networksecuritygroup` | 🟢 / 🟢 |
| `Microsoft.Network/publicIPAddresses` | `avm/res/network/public-ip-address` | `avm-res-network-publicipaddress` | 🟢 / 🟢 |
| `Microsoft.Network/networkInterfaces` | `avm/res/network/network-interface` | `avm-res-network-networkinterface` | 🟢 / 🟢 |
| `Microsoft.Network/privateEndpoints` | `avm/res/network/private-endpoint` | `avm-res-network-privateendpoint` | 🟢 / 🟢 |
| `Microsoft.Compute/virtualMachines` | `avm/res/compute/virtual-machine` | `avm-res-compute-virtualmachine` | 🟢 / 🟢 |
| `Microsoft.Web/serverfarms` | `avm/res/web/serverfarm` | `avm-res-web-serverfarm` | 🟢 / 🟢 |
| `Microsoft.Web/sites` | `avm/res/web/site` | `avm-res-web-site` | 🟢 / 🟢 |
| `Microsoft.ContainerRegistry/registries` | `avm/res/container-registry/registry` | `avm-res-containerregistry-registry` | 🟢 / 🟢 |
| `Microsoft.ContainerService/managedClusters` | `avm/res/container-service/managed-cluster` | `avm-res-containerservice-managedcluster` | 🟢 / 🟢 |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | `avm/res/managed-identity/user-assigned-identity` | `avm-res-managedidentity-userassignedidentity` | 🟢 / 🟢 |
| `Microsoft.OperationalInsights/workspaces` | `avm/res/operational-insights/workspace` | `avm-res-operationalinsights-workspace` | 🟢 / 🟢 |
| `Microsoft.Insights/components` | `avm/res/insights/component` | `avm-res-insights-component` | 🟢 / 🟢 |
| `Microsoft.Sql/servers` | `avm/res/sql/server` | `avm-res-sql-server` | 🟢 / 🟢 |
| `Microsoft.Synapse/workspaces` | `avm/res/synapse/workspace` | `avm-res-synapse-workspace` | 🟢 / ⚪ |

## Coverage is asymmetric — language choice is load-bearing

The Bicep index carries **~530** resource-module rows; Terraform carries **~150**. Many types are
`Available` for Bicep but only `Proposed` (or absent) for Terraform. Two consequences the resolver
enforces:

1. **Resolve against the chosen language's index only.** Never assume a Bicep module implies a
   Terraform module. `Microsoft.Synapse/workspaces` is the canonical trap: 🟢 Bicep, ⚪ Terraform.
2. **Coverage % is a first-class output.** If a target scope resolves to 95% coverage in Bicep but
   60% in Terraform, that belongs in the intake decision — surface it, don't bury it.

## Child resources

Prefer folding a child type into its **parent module's inputs** over emitting a separate child
call. Example: `Microsoft.Storage/storageAccounts/blobServices/containers` is best expressed as a
`containers` entry inside the `storage-account` module's `blobServices` input, not a standalone
`avm/res/storage/storage-account/blob-service/container` call. Emit a dedicated child-module call
only when the child is in scope but its parent is not (and, for Terraform, the child usually has no
separate module at all — it is always an input).
