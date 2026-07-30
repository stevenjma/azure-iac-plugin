# AVM version resolution

The index tells you *which* module owns a type. It does **not** give you a usable version — the
Bicep CSV's `PublicRegistryReference` ends in a literal `X.Y.Z` placeholder. This reference is how
the resolver turns a module name into a **pinned** source string.

**Rule: always pin an explicit version. Never float `latest`, never ship the `X.Y.Z` placeholder.**
A brownfield adoption must be reproducible; an unpinned module can silently change the generated
infrastructure between two runs.

## Bicep — Microsoft Container Registry (MCR) tags

AVM Bicep modules are published to the public Bicep registry, backed by MCR. List tags:

```
GET https://mcr.microsoft.com/v2/bicep/avm/res/<provider>/<type>/tags/list
```

The path segment after `bicep/` is exactly the `ModuleName` from the index. Example:

```powershell
$ProgressPreference = 'SilentlyContinue'
$m = 'storage/storage-account'   # = ModuleName without the avm/res/ prefix
$tags = (Invoke-WebRequest -UseBasicParsing "https://mcr.microsoft.com/v2/bicep/avm/res/$m/tags/list").Content |
        ConvertFrom-Json
# newest stable (AVM uses semver; skip any pre-release suffixes)
$latest = $tags.tags |
  Where-Object { $_ -match '^\d+\.\d+\.\d+$' } |
  Sort-Object { [version]$_ } | Select-Object -Last 1
"br/public:avm/res/$m`:$latest"   # e.g. br/public:avm/res/storage/storage-account:0.32.1
```

Emit into Bicep as:

```bicep
module sa 'br/public:avm/res/storage/storage-account:0.32.1' = {
  name: 'sa-deploy'
  params: { /* wired by -inputs */ }
}
```

`bicep restore` (implicit on `az bicep build`) pulls the pinned module from MCR — this is why the
Bicep fidelity gate needs `mcr.microsoft.com` egress.

## Terraform — Terraform Registry

AVM Terraform modules are published to the public Terraform Registry under the `Azure` namespace,
`azurerm` target:

```
GET https://registry.terraform.io/v1/modules/Azure/<ModuleName>/azurerm            # latest
GET https://registry.terraform.io/v1/modules/Azure/<ModuleName>/azurerm/versions   # all versions
```

`<ModuleName>` is the index value verbatim (e.g. `avm-res-storage-storageaccount`). Example:

```powershell
$mod = 'avm-res-storage-storageaccount'
$latest = ((Invoke-WebRequest -UseBasicParsing "https://registry.terraform.io/v1/modules/Azure/$mod/azurerm").Content |
           ConvertFrom-Json).version               # e.g. 0.7.3
```

Emit into Terraform as:

```hcl
module "storage_account" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.7.3"
  # inputs wired by -inputs
}
```

`terraform init` pulls the pinned module from the Registry — this is why the Terraform lane needs
Registry egress.

## Choosing the version

- Default to the **newest stable** (highest non-prerelease semver) unless the user pins a floor.
- AVM resource modules are pre-1.0 (`0.y.z`); a minor bump can carry interface changes. Record the
  exact version you pinned in `coverage.json` so a re-run is deterministic.
- If the user supplies a version constraint (org-approved baseline), honor it and pick the highest
  matching tag; if nothing matches, that is a gap, not a silent downgrade.
- Never mix: a single composition pins one version per module. Do not float minor with `~>` in the
  generated Terraform for brownfield adoption — write the exact `version = "x.y.z"`.

## Offline / no-egress fallback

If MCR or the Registry is unreachable:

1. Use a version the user or org baseline supplies explicitly.
2. Otherwise mark the type a **version-unresolved gap** in `coverage.json` (fallback
   `raw-resource`) rather than guessing — an unverifiable version is worse than a raw block.

Do not hardcode versions from this document into generated output — the numbers here
(`0.32.1`, `0.7.3`) are illustrative snapshots and will be stale. Resolve live at compose time.
