# brownfield-iac-export — concrete invocations

Exact, works-today commands for the **direct ARM REST** dispatch tier (tier 3). All use `az rest`,
which attaches the caller's AAD bearer token automatically. Windows PowerShell syntax.

> Dispatch order reminder: try (1) an ARM MCP RP export tool, then (2) the ARM MCP generic
> POST-action path, and only then (3) these `az rest` calls. Tiers (1)/(2) upgrade the *mechanism*
> without changing anything downstream.

---

## 0. Auth / scope preamble

```powershell
az account show --query "{sub:id, name:name, tenant:tenantId}" -o json
$subId = az account show --query id -o tsv
```

Switch subscription if the scope lives elsewhere: `az account set --subscription <subId>`.

---

## 1. Terraform export — `Microsoft.AzureTerraform/exportTerraform` (LRO)

### 1a. Kick off the export

Write the body to a temp file (avoids PowerShell quote-escaping pain), then POST:

```powershell
$subId   = az account show --query id -o tsv
$apiVer  = "2025-09-01-preview"
$bodyPath = Join-Path $env:TEMP "export-tf-body.json"

# Resource group scope (azurerm). Swap the object for other scopes — see table below.
@{
  type              = "ExportResourceGroup"
  resourceGroupName = "rg1"
  targetProvider    = "azurerm"     # or "azapi"
  maskSensitive     = $true
} | ConvertTo-Json | Set-Content -Encoding utf8 $bodyPath

$uri = "https://management.azure.com/subscriptions/$subId/providers/Microsoft.AzureTerraform/exportTerraform?api-version=$apiVer"

# -i so we can read the 202 headers (Azure-AsyncOperation). Small scopes may return 200 inline.
az rest --method post --uri $uri --headers "Content-Type=application/json" --body "@$bodyPath" -i
```

Scope body variants (the `type` discriminator selects the shape):

| Scope | Body object |
|---|---|
| Resource group | `@{ type="ExportResourceGroup"; resourceGroupName="rg1" }` |
| Resource(s) by ID | `@{ type="ExportResource"; resourceIds=@("/subscriptions/$subId/resourceGroups/rg1/providers/Microsoft.Network/virtualNetworks/vnet1") }` |
| ARG query | `@{ type="ExportQuery"; query='type =~ "microsoft.network/virtualnetworks" and resourceGroup =~ "rg1"' }` |

Common optional keys (all lanes): `targetProvider` (`azurerm`\|`azapi`, default azurerm),
`namePattern` (default `res-`), `maskSensitive` (default true), `fullProperties` (default true),
`includeResourceGroup`, `excludeAzureResource` (regex array), `excludeTerraformResource`
(e.g. `@("azurerm_virtual_network")`).

### 1b. Poll the async operation (`az rest` does NOT auto-poll LROs)

Grab the `Azure-AsyncOperation` URL from the 202 headers and poll it until terminal:

```powershell
$opUrl = "<Azure-AsyncOperation header value from step 1a>"

do {
  Start-Sleep -Seconds 5
  $op = az rest --method get --uri $opUrl | ConvertFrom-Json
  Write-Host "status: $($op.status)  percent: $($op.percentComplete)"
} while ($op.status -notin @("Succeeded","Failed","Canceled"))

if ($op.status -ne "Succeeded") { throw "export failed: $($op.error.message)" }
```

If step 1a returned **200 inline**, `$op` is just that JSON body — skip the poll loop.

### 1c. Extract results → files

```powershell
$work = ".\export-out"; New-Item -ItemType Directory -Force $work | Out-Null
$op.properties.configuration | Set-Content -Encoding utf8 (Join-Path $work "main.tf")
$op.properties.import        | Set-Content -Encoding utf8 (Join-Path $work "import.tf")

# Surface non-fatal outcomes:
$op.properties.skippedResources   # resources not exportable (azurerm users can retry azapi)
$op.properties.errors             # per-resource errors
```

`main.tf` = `properties.configuration` (HCL). `import.tf` = `properties.import` (import blocks).

---

## 2. Bicep export — `exportTemplate` → `bicep decompile`

### 2a. Export the ARM JSON

```powershell
$subId  = az account show --query id -o tsv
$rg     = "rg1"
$work   = ".\export-out"; New-Item -ItemType Directory -Force $work | Out-Null
$bodyPath = Join-Path $env:TEMP "export-arm-body.json"

@{
  resources = @("*")
  options   = "IncludeParameterDefaultValue,SkipResourceNameParameterization"
} | ConvertTo-Json | Set-Content -Encoding utf8 $bodyPath

$uri = "https://management.azure.com/subscriptions/$subId/resourceGroups/$rg/exportTemplate?api-version=2021-04-01"

# Response has a .template property = the ARM JSON. Persist just that.
$resp = az rest --method post --uri $uri --headers "Content-Type=application/json" --body "@$bodyPath" | ConvertFrom-Json
$resp.template | ConvertTo-Json -Depth 100 | Set-Content -Encoding utf8 (Join-Path $work "template.json")
```

CLI wrapper equivalent (either is fine): `az group export --name $rg --include-parameter-default-value`.

### 2b. Decompile to Bicep + build sanity check

```powershell
az bicep decompile --file (Join-Path $work "template.json")   # emits main.bicep beside it; prints warnings
az bicep build     --file (Join-Path $work "main.bicep") --stdout | Out-Null  # hard failure => invalid decompile
```

Collect decompile **warnings** — they mark constructs that didn't round-trip and are the primary
`bicep-cleanup` targets (parameterization, `@secure()`, module extraction).

---

## 3. Dispatch probe (tiers 1 → 2 → 3)

Pseudocode the skill follows before falling back to `az rest`:

```
if session exposes an ARM MCP tool whose name/description matches
   AzureTerraform export / exportTerraform / exportTemplate:
        → call it with the scope body; done.        # tier 1 (RP tool)
elif ARM MCP exposes list_available_actions / submit_resource_action:
        list_available_actions(scope)
        generate_resource_action_body(action = exportTerraform|exportTemplate)
        submit_resource_action(...)                  # tier 2 (generic POST-action)
else:
        use the az rest calls above.                 # tier 3 (works-today POC)
```

Never hard-fail solely because the ARM MCP is unwired — tier 3 always works with `az login`.

---

## 4. Guardrail reminders (enforced by the skill, restated here)

- Read/export only. Never `terraform apply` or `az deployment group create`.
- Never install `terraform` / `bicep` silently — STOP with instructions.
- Strip provider credentials and hardcoded `subscription_id` before handoff (see SKILL Phase 2).
- One resource's export error never aborts the batch — collect and report.
