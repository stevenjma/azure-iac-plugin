# brownfield-avm-adopt — concrete invocations

Works-today commands for AVM adoption. Discovery + harvest use the **direct ARM REST** dispatch
tier (tier 3) via `az rest`, which attaches the caller's AAD bearer token automatically. Windows
PowerShell syntax.

> Dispatch order reminder: try (1) an ARM MCP RP tool, then (2) the ARM MCP generic POST-action
> path, and only then (3) these `az rest` calls. Tiers (1)/(2) upgrade the *mechanism* without
> changing anything downstream. Here the harvested output is consumed as **input values for AVM
> module calls**, not as final code.

---

## 0. Auth / scope preamble

```powershell
az account show --query "{sub:id, name:name, tenant:tenantId}" -o json
$subId = az account show --query id -o tsv
```

Switch subscription if the scope lives elsewhere: `az account set --subscription <subId>`.

---

## 1. Discover in-scope types (Azure Resource Graph)

The type inventory drives coverage resolution — run it before generating anything.

```powershell
# Requires the resource-graph extension (az extension add --name resource-graph).
$rg = "rg1"
az graph query -q @"
Resources
| where resourceGroup =~ '$rg'
| summarize count() by type, apiVersion
| order by type asc
"@ -o table
```

ARM REST equivalent (no extension needed):

```powershell
$body = @{ query = "Resources | where resourceGroup =~ 'rg1' | summarize count() by type, apiVersion" } |
        ConvertTo-Json
az rest --method post `
  --uri "https://management.azure.com/providers/Microsoft.ResourceGraph/resources?api-version=2022-10-01" `
  --headers "Content-Type=application/json" --body $body | ConvertFrom-Json |
  Select-Object -Expand data
```

Output → the `type` list handed to `avm-module-resolver` in step 3.

---

## 2. Harvest live config (the oracle)

Two equivalent ways to get the live property bag. Consume the result as **input values**.

### 2a. Whole resource group — `exportTemplate` (one call, ARM JSON)

```powershell
$subId = az account show --query id -o tsv
$rg    = "rg1"
$work  = ".\avm-out"; New-Item -ItemType Directory -Force "$work\.avm\harvest" | Out-Null
$bodyPath = Join-Path $env:TEMP "harvest-arm-body.json"

@{
  resources = @("*")
  options   = "IncludeParameterDefaultValue,SkipResourceNameParameterization"
} | ConvertTo-Json | Set-Content -Encoding utf8 $bodyPath

$uri  = "https://management.azure.com/subscriptions/$subId/resourceGroups/$rg/exportTemplate?api-version=2021-04-01"
$resp = az rest --method post --uri $uri --headers "Content-Type=application/json" --body "@$bodyPath" | ConvertFrom-Json

# Split each resource's property bag into its own oracle file (name = resource name).
foreach ($r in $resp.template.resources) {
  $name = ($r.name -replace "[\[\]',/]", "_")
  $r | ConvertTo-Json -Depth 100 | Set-Content -Encoding utf8 "$work\.avm\harvest\$name.json"
}
```

> The property bag is the oracle. Unlike the raw plugin, we do **not** decompile this ARM JSON into
> code — the compose lane reads these `.avm/harvest/*.json` files to fill AVM module inputs.

### 2b. Single resource — direct GET (freshest, full properties)

```powershell
$id  = "/subscriptions/$subId/resourceGroups/rg1/providers/Microsoft.Storage/storageAccounts/sa1"
$ver = "2023-05-01"   # use the apiVersion discovered in step 1
az rest --method get --uri "https://management.azure.com$id?api-version=$ver" |
  Set-Content -Encoding utf8 ".\avm-out\.avm\harvest\sa1.json"
```

---

## 3. Resolve coverage (hand off to `avm-module-resolver`)

Give the resolver the step-1 type list + chosen language. It fetches the AVM index and writes
`coverage.json`. The index fetch (see `avm-module-resolver/reference/module-index.md`):

```powershell
$ProgressPreference = 'SilentlyContinue'
$base = 'https://raw.githubusercontent.com/Azure/Azure-Verified-Modules/main/docs/static/module-indexes'
$idx  = (Invoke-WebRequest -UseBasicParsing "$base/BicepResourceModules.csv").Content | ConvertFrom-Csv
# join: split each in-scope "Microsoft.X/y" on the first '/', match ProviderNamespace + ResourceType.
```

### Shape of `.avm/coverage.json`

```json
{
  "language": "bicep",
  "scope": { "kind": "resourceGroup", "target": "rg1" },
  "resolved": [
    { "type": "Microsoft.Storage/storageAccounts",
      "module": "avm/res/storage/storage-account",
      "source": "br/public:avm/res/storage/storage-account:0.32.1",
      "version": "0.32.1", "status": "Available" },
    { "type": "Microsoft.KeyVault/vaults",
      "module": "avm/res/key-vault/vault",
      "source": "br/public:avm/res/key-vault/vault:0.x.y",
      "version": "0.x.y", "status": "Available" }
  ],
  "gaps": [
    { "type": "Microsoft.Foo/bars", "status": "absent", "fallback": "raw-resource" }
  ],
  "coveragePct": 66.7
}
```

Terraform `resolved[]` entries carry `"source": "Azure/avm-res-storage-storageaccount/azurerm"` +
`"version": "0.7.3"` instead of the `br/public:` string.

---

## 4. Dispatch probe (tiers 1 → 2 → 3)

```
if session exposes an ARM MCP tool for export/read of the scope:
        → call it; consume the property bag as oracle input.   # tier 1
elif ARM MCP exposes list_available_actions / submit_resource_action:
        → drive the generic POST-action path.                  # tier 2
else:
        → use the az rest calls above.                         # tier 3 (works-today)
```

Never hard-fail solely because the ARM MCP is unwired — tier 3 always works with `az login`.

---

## 5. Guardrail reminders (enforced by the skill, restated here)

- Read/harvest only. Never `terraform apply` or `az deployment group create`.
- Resolve coverage against the chosen language's index only — coverage is asymmetric.
- Surface coverage % before composing; low coverage is an intake decision.
- Never install `terraform` / `bicep` silently — STOP with instructions.
- Flag harvested secrets for the compose `-secrets` pass; never write them as literals.
- One resource's harvest error never aborts the batch — collect and report.
