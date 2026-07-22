<#
  strip-orphan-imports.ps1 — auto-remediate orphaned Terraform import blocks
  emitted by Microsoft.AzureTerraform exportTerraform.

  Grounded in the live export-result schema:
    properties.import            HCL text: import { id=.. to=<type>.<name> }
    properties.configuration     HCL text: resource "<type>" "<name>" { .. }
    properties.errors[]          { code:"ImportError", message:"Importing <ID> as <addr>", target:<ID> }
    properties.skippedResources  [ "<ARM ID>", .. ]

  Two live-proven orphan causes are swept:
    1. failed-import  — addr appears in errors[] (import will 401/403 at plan time)
    2. skipped-target — import.to addr has no matching resource{} block
#>
param(
  [Parameter(Mandatory)] [string] $ExportResultJson,   # path to the op result JSON
  [Parameter(Mandatory)] [string] $ImportTf,           # path to import.tf (may equal source)
  [switch] $WriteChanges                               # off = dry-run report only
)

$op = Get-Content $ExportResultJson -Raw | ConvertFrom-Json
$p  = $op.properties

# 1. failed-import orphans: parse the TF address after " as " in each ImportError message
$failed = @{}
foreach ($e in @($p.errors)) {
  if ($e.code -ne 'ImportError') { continue }
  if ($e.message -match ' as ([a-z0-9_]+\.[A-Za-z0-9_\-]+)\s*$') {
    $failed[$Matches[1]] = ($e.additionalInfo.info.'message:' -join ' ')
  }
}

# 2. declared resource addresses, from configuration HCL
$declared = [System.Collections.Generic.HashSet[string]]::new()
[regex]::Matches($p.configuration, '(?m)^\s*resource\s+"([^"]+)"\s+"([^"]+)"') |
  ForEach-Object { [void]$declared.Add("$($_.Groups[1].Value).$($_.Groups[2].Value)") }

# 3. walk every import block; classify + rebuild import.tf without orphans
$blocks = [regex]::Matches($p.import, '(?s)import\s*\{.*?\}')
$kept = New-Object System.Collections.Generic.List[string]
$stripped = New-Object System.Collections.Generic.List[object]
foreach ($b in $blocks) {
  $txt = $b.Value
  $addr = if ($txt -match 'to\s*=\s*([a-z0-9_]+\.[A-Za-z0-9_\-]+)') { $Matches[1] } else { $null }
  if     ($addr -and $failed.ContainsKey($addr))       { $stripped.Add([pscustomobject]@{addr=$addr; cause='failed-import'; evidence=$failed[$addr]}) }
  elseif ($addr -and -not $declared.Contains($addr))   { $stripped.Add([pscustomobject]@{addr=$addr; cause='skipped-target'; evidence='no matching resource{} block'}) }
  else   { $kept.Add($txt) }
}

# 4. report
"orphan-import remediation — $($blocks.Count) import blocks, $($stripped.Count) orphan(s) stripped, $($kept.Count) kept"
foreach ($s in $stripped) { "  STRIP  {0,-45} {1}" -f $s.addr, $s.cause }
if ($p.skippedResources) { "  (context) skippedResources: $((@($p.skippedResources)).Count)" }

if ($WriteChanges) {
  ($kept -join "`n`n") + "`n" | Set-Content $ImportTf -Encoding utf8
  "  wrote $($kept.Count) clean import blocks -> $ImportTf"
}
