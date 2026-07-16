---
name: azure-to-terraform-translation
description: >
  Fix semantic mismatches between Azure API return values and what azurerm/azapi Terraform providers
  accept. 30+ translation rules covering enum normalization, sentinel values, write-only secrets,
  path mismatches, and provider bugs. Use when "terraform plan" shows drift or validate fails after import.
license: MIT
compatibility: >
  Provider-schema doc enrichment (Terraform Registry / `terraform providers schema -json`,
  or ARM MCP resource-type schema tools) recommended for enum lookups; the built-in pattern
  library works standalone.
metadata:
  version: "1.1"
  author: Stephen Ma
---

> **Purpose**: Fix the semantic mismatch between Azure API return values and what the azurerm/azapi Terraform providers actually accept. This skill encodes known translation patterns discovered from source-code analysis of `aztfexport`, `aztfmigrate`, the `azurerm` provider internals, and real-world brownfield conversions.

## Prerequisites

This skill works best with a **provider-schema doc source** for enum/default lookups:
- **Terraform Registry docs** or `terraform providers schema -json` for the azurerm/azapi providers
- Optionally the **ARM MCP** resource-type schema tools (`get_resource_type_schema`) to confirm
  the live Azure-side shape of a field

Use these for:
- Looking up valid enum values when fixing Rule 1.x issues
- Verifying resource schema when determining if a field is computed-only or write-only
- Confirming default values for empty-string enum replacement (Rule 1.6)

If no doc source is wired, the skill still applies its built-in pattern library, but may require
more manual lookups for edge cases.

> Note: `exportTerraform` (the ARM control-plane export action) runs the same aztfexport engine
> **server-side**, so the drift/translation patterns below apply identically to its output —
> the historical `aztfexport` root-cause notes remain accurate.

## When to Invoke

This skill should be called by the `terraform-cleanup` skill (or directly) whenever:
- `terraform validate` or `terraform plan` fails after `terraform plan -generate-config-out`
- You're refining raw HCL generated from import blocks
- You encounter provider validation errors on imported state values
- Plan shows perpetual drift on fields that haven't actually changed

## Architecture

```
Azure API State → terraform import → Raw HCL (broken) → THIS SKILL → Valid HCL
```

The core problem: Azure APIs return values in formats/ranges the azurerm provider rejects during validation or plan. These are **not bugs** — they're translation gaps between two different schemas for the same infrastructure.

**Sources**: Rules derived from:
- `hashicorp/terraform-provider-azurerm` `internal/tf/suppress/` package (89+ DiffSuppressFunc usages)
- `Azure/aztfexport` `internal/meta/base_meta.go` (lifecycle addon, terraform-cleanup logic)
- `Azure/aztfmigrate` `azurerm/hcl_schema.go` (TuneHCLSchemaForResource)
- Real-world brownfield conversions and GitHub issues

---

## Translation Rules

---

### Category 1: Enum & Case Normalization

#### Rule 1.1: Key Vault "all" Permissions Shorthand

**Trigger**: `expected access_policy.N.{type}_permissions.0 to be one of [...], got all`

**Root Cause**: Azure KV API returns `"all"` shorthand; azurerm only accepts explicit enum values.

**Fix**: Expand to full lists:
```hcl
certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", "Purge"]
key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Decrypt", "Encrypt", "UnwrapKey", "WrapKey", "Verify", "Sign", "Purge", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
storage_permissions     = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "RegenerateKey", "Purge"]
```

**Plan Impact**: 1 change (normalization). Functionally equivalent — accept as intentional.

#### Rule 1.2: Resource ID Case Inconsistency (89+ resources)

**Trigger**: `terraform plan` shows drift on ID reference fields (e.g., `subnet_id`, `disk_access_id`, `linked_resource_id`) despite no actual change.

**Root Cause**: Azure ARM APIs return resource IDs with inconsistent casing. Known confirmed cases:
- **EventHub** subnet_id: RG name returned in lowercase (Azure SDK bug #5855)
- **Snapshot** disk_access_id: RG name returned in UPPERCASE (REST spec bug #29187)
- **Container Apps** registry identity: No normalization applied
- **Network Security Rules**: Application Security Group IDs vary

**Provider Mechanism**: `suppress.CaseDifference` (deprecated, 89 usages) or `ParseXxxIDInsensitively()` in Read.

**Fix for imported code**: Use `lifecycle { ignore_changes }` on affected ID fields, OR ensure your ID references use `azurerm_*.id` resource references (which are always canonical):
```hcl
# Replace literal IDs with resource references where possible
subnet_id = azurerm_subnet.example.id  # canonical casing guaranteed
```

#### Rule 1.3: NSG Protocol Enum Case

**Trigger**: Plan drift on `protocol` field in `azurerm_network_security_rule`.

**Root Cause**: Azure returns `"tcp"` or `"TCP"` but provider ValidateFunc expects `"Tcp"`. The provider normalizes in Read via a protocol map (issue #16092).

**Fix**: Ensure protocol values use title case: `"Tcp"`, `"Udp"`, `"Icmp"`, `"Esp"`, `"Ah"`, `"*"`.

#### Rule 1.4: Location String Normalization

**Trigger**: Plan shows location change (e.g., `"East US"` → `"eastus"`).

**Root Cause**: Azure returns display names (`"East US"`) or canonical (`"eastus"`) depending on API version. Provider normalizes via `location.Normalize()` (lowercase, no spaces).

**Fix**: Always use canonical form: `"eastus"`, `"westeurope"`, `"australiaeast"`. The provider handles this automatically in Read, so this rarely manifests after first plan.

#### Rule 1.5: Key Vault Versioned vs. Versionless URL

**Trigger**: Plan drift on `key_vault_secret_id` showing version GUID appended.

**Root Cause**: User writes versionless URL (`https://vault.vault.azure.net/secrets/name`), Azure returns versioned (`https://vault.vault.azure.net/secrets/name/abc123`). Provider suppresses via `DiffSuppressIgnoreKeyVaultKeyVersion`.

**Affected**: `azurerm_app_service_certificate.key_vault_secret_id`, and any field referencing KV items.

**Fix**: Use versionless URLs in config. The provider suppresses the version diff. For `azurerm_key_vault_certificate` import: you MUST provide the versioned URL (it requires `VersionTypeVersioned`).

#### Rule 1.6: Empty-String Enum Attributes (aztfexport artifact)

**Trigger**: `expected <field> to be one of ["Allow" "Deny"], got `  (empty string)

**Root Cause**: aztfexport exports enum-constrained attributes as `""` (empty string) when the attribute wasn't explicitly set on the Azure resource (uses platform default). The azurerm provider's ValidateFunc rejects empty strings — it requires one of the defined enum values.

**Affected resources** (common, non-exhaustive):
- `azurerm_windows_web_app` / `azurerm_linux_web_app`: `site_config.ip_restriction_default_action`, `site_config.scm_ip_restriction_default_action`
- `azurerm_storage_account`: `public_network_access_enabled` (reported as `""` vs `"Enabled"`)
- `azurerm_cosmosdb_account`: `public_network_access`
- Any resource with `*_action`, `*_access`, `*_policy` enum fields

**Detection strategy**: When fetching provider documentation for a resource type, build a list of all enum-constrained fields. After export, scan for any of those fields set to `""`. Flag them immediately — don't wait for `terraform plan` to fail.

**Fix**:
```hcl
# BEFORE (aztfexport output — invalid)
ip_restriction_default_action     = ""
scm_ip_restriction_default_action = ""

# AFTER (set to platform default)
ip_restriction_default_action     = "Allow"
scm_ip_restriction_default_action = "Allow"
```

**Resolution priority**:
1. If provider docs specify a `Default` value → use that
2. If no default documented → query the Azure resource's current value via `az resource show` and use the live value
3. If attribute is optional and empty means "not set" → remove the line entirely

**Plan Impact**: 0 to change after fix (state already has the correct value; the config was just invalid).

---

### Category 2: Out-of-Range Sentinel Values

#### Rule 2.1: Zero-Value Retention Days

**Trigger**: `expected {field} to be in the range (1 - N), got 0`

**Root Cause**: Azure uses `0` = "disabled" but azurerm requires valid range if field is present.

**Affected Resources**:
- `azurerm_storage_account_queue_properties` → `retention_policy_days`
- `azurerm_storage_account` → `blob_properties.0.change_feed_retention_in_days`
- Any `retention_in_days` / `retention_policy_days` field

**Fix**: Remove the field entirely (omission = disabled):
```hcl
# BEFORE (broken)
hour_metrics {
  enabled               = false
  retention_policy_days = 0   # ← REMOVE
}
# AFTER (valid)
hour_metrics {
  enabled = false
}
```

#### Rule 2.2: Default Boolean Fields Not Marked Computed

**Trigger**: Plan shows `+ connectivity_logs_enabled = false` as an addition after import.

**Root Cause**: Fields like `connectivity_logs_enabled`, `messaging_logs_enabled` default to `false` on the API side but aren't marked `Computed` in schema. After import, state has `false` but config has `null` (omitted) → spurious diff.

**Affected**: `azurerm_signalr_service`, potentially any resource with Optional bool fields that default false.

**Fix**: Explicitly set the field to `false` in config to match state:
```hcl
connectivity_logs_enabled  = false
messaging_logs_enabled     = false
http_request_logs_enabled  = false
```

---

### Category 3: Invalid/Sentinel Attribute Values

#### Rule 3.1: Storage Encryption Scope "$account-encryption-key"

**Trigger**: `storage encryption scope name "$account-encryption-key" must be alphanumeric`

**Root Cause**: Azure returns internal sentinel `$account-encryption-key` for account-level default. Contains `$` and `-` = invalid.

**Fix**: Remove both `default_encryption_scope` AND `encryption_scope_override_enabled` (co-dependent):
```hcl
# Remove both — account default encryption is implicit behavior
```

#### Rule 3.2: VM Admin Password "ignored-as-imported" Sentinel

**Trigger**: After importing a VM, `admin_password` field contains literal `"ignored-as-imported"`.

**Root Cause**: The azurerm provider sets this sentinel during import because the API never returns passwords. The provider's `adminPasswordDiffSuppressFunc` treats any comparison involving this sentinel as equal.

**Affected**: `azurerm_linux_virtual_machine`, `azurerm_windows_virtual_machine`, all VMSS variants.

**Fix**: Replace with actual password variable:
```hcl
variable "vm_admin_password" {
  type      = string
  sensitive = true
}

resource "azurerm_windows_virtual_machine" "example" {
  admin_password = var.vm_admin_password
  lifecycle {
    ignore_changes = [admin_password]
  }
}
```

**Warning**: After import, Terraform NEVER detects password drift on these resources.

---

### Category 4: Secrets & Write-Only Fields

#### Rule 4.1: ML Datastore Credentials

**Trigger**: `one of 'account_key,shared_access_signature' must be specified`

**Root Cause**: Datastores require storage credential at creation even with managed identity. Generated HCL has `null # sensitive`.

**Affected**: All `azurerm_machine_learning_datastore_*` resources.

**Fix**: Sensitive variable + lifecycle ignore:
```hcl
variable "storage_account_key" {
  type      = string
  sensitive = true
}

resource "azurerm_machine_learning_datastore_blobstorage" "example" {
  account_key = var.storage_account_key
  lifecycle { ignore_changes = [account_key, shared_access_signature] }
}
```

#### Rule 4.2: Generic Write-Only Properties (No API GET Return)

**Trigger**: `Missing required argument` on fields that are write-only.

**Root Cause**: Azure API accepts on PUT but never returns on GET. `terraform import` reads state via GET → field is empty. aztfexport cannot export what the API won't return.

**Known Affected Resources**:
| Resource | Missing Field(s) |
|----------|-----------------|
| `azurerm_app_service_certificate` | `pfx_blob` OR `key_vault_secret_id` |
| `azurerm_frontdoor` | `cache_duration`, `web_application_firewall_policy_link_id` |
| `azurerm_linux_function_app` | `ip_restriction_default_action` |
| `azurerm_cdn_frontdoor_firewall_policy` | `action`, `selector` |

**Fix**: These MUST be manually populated. Generate a variables file with `# REQUIRED: manual input` comments:
```hcl
variable "app_cert_pfx_blob" {
  description = "MANUAL: Base64-encoded PFX certificate (write-only, cannot be exported)"
  type        = string
  sensitive   = true
}
```

#### Rule 4.3: Invalid Attribute Name "service_data_identity"

**Trigger**: Validation error or silent drift on fileshare datastores.

**Root Cause**: Generated HCL uses `service_data_identity` (wrong) instead of `service_data_auth_identity` (correct).

**Fix**: Remove the invalid attribute entirely. Auth handled by Rule 4.1.

---

### Category 5: Cross-Resource ID Format Mismatches

#### Rule 5.1: Storage `/shares/` vs `/fileshares/` Segment

**Trigger**: Perpetual drift on `storage_fileshare_id`.

**Root Cause**: `azurerm_storage_share.id` uses `/shares/` but ML datastores expect `/fileshares/`.

**Fix**: Use interpolation or lifecycle ignore:
```hcl
storage_fileshare_id = "${azurerm_storage_account.example.id}/fileServices/default/fileshares/${azurerm_storage_share.example.name}"
```

#### Rule 5.2: Monitor Diagnostic Setting Pipe-Delimited IDs

**Trigger**: Import fails or produces wrong resource associations.

**Root Cause**: `azurerm_monitor_diagnostic_setting` uses composite IDs: `<target_id>|<setting_name>`. `azurerm_role_definition` uses `<role_id>|<scope>`. These pipe-delimited formats don't match Azure ARM resource IDs.

**Fix**: When importing these resources, ensure the import ID uses the pipe-delimited format:
```hcl
import {
  to = azurerm_monitor_diagnostic_setting.example
  id = "/subscriptions/.../resourceGroups/.../providers/.../myResource|myDiagSetting"
}
```

#### Rule 5.3: Key Vault Certificate Requires Versioned Import ID

**Trigger**: `terraform import` of `azurerm_key_vault_certificate` fails with parse error when using versionless URL.

**Root Cause**: The certificate importer requires `VersionTypeVersioned` while the secret importer accepts `VersionTypeAny`.

**Fix**: Always include the version GUID when importing certificates:
```hcl
import {
  to = azurerm_key_vault_certificate.example
  id = "https://vault.vault.azure.net/certificates/my-cert/abc123def456"
}
```

---

### Category 6: Structural / Schema Mismatches

#### Rule 6.1: Co-Dependent Attributes (encryption_scope)

**Trigger**: `all of 'default_encryption_scope,encryption_scope_override_enabled' must be specified`

**Fix**: Provide both or remove both. See Rule 3.1.

#### Rule 6.2: ExactlyOneOf Alphabetical Selection

**Trigger**: After export, the wrong attribute from an `ExactlyOneOf` pair is populated (the other is null).

**Root Cause**: `aztfmigrate`/`tfadd` resolves `ExactlyOneOf` constraints by keeping only the **alphabetically first** attribute. If the resource actually uses the second attribute, the exported value is wrong/null.

**Known Case**: `azurerm_network_watcher_flow_log` — `network_security_group_id` (kept) vs `target_resource_id` (dropped). VNet flow logs use `target_resource_id`.

**Fix**: Check which attribute the resource actually uses and swap:
```hcl
# If aztfexport produced network_security_group_id = null, 
# but this is a VNet flow log:
resource "azurerm_network_watcher_flow_log" "example" {
  target_resource_id = "/subscriptions/.../providers/Microsoft.Network/virtualNetworks/myVnet"
  # Remove: network_security_group_id = null
}
```

#### Rule 6.3: Block vs. Attribute Format (TypeList rendering)

**Trigger**: `terraform validate` fails because a nested block is rendered as an attribute assignment.

**Root Cause**: `tfadd` sometimes renders TypeList/TypeSet as `field = [{ ... }]` (attribute syntax) when the provider expects block syntax `field { ... }`.

**Known Case**: `azurerm_site_recovery_replicated_vm` → `managed_disk` (issue #449).

**Fix**: Convert attribute syntax to block syntax:
```hcl
# BEFORE (broken)
managed_disk = [{ disk_id = "..." target_disk_type = "Standard_LRS" }]

# AFTER (valid)
managed_disk {
  disk_id          = "..."
  target_disk_type = "Standard_LRS"
}
```

#### Rule 6.4: Inline vs. Standalone Child Resources

**Trigger**: Plan drift when mixing aztfexport output with existing code that uses inline definitions.

**Root Cause**: aztfexport ALWAYS generates standalone resource blocks (`azurerm_subnet`, `azurerm_network_security_rule`) even when the provider supports inline definition in the parent (`azurerm_virtual_network.subnet = [...]`).

**Fix**: Choose one style and be consistent. If existing code uses inline, consolidate:
```hcl
# aztfexport generates:
resource "azurerm_subnet" "example" { ... }

# But you may need:
resource "azurerm_virtual_network" "example" {
  subnet { ... }  # inline style
}
```

---

### Category 7: Format Normalization (Provider Handles Automatically)

These are patterns the provider handles via DiffSuppressFunc. You generally don't need to fix these manually, but be aware they exist:

#### Rule 7.1: SSH Key Whitespace/Line Endings

**Provider Mechanism**: `suppress.SSHKey` strips heredoc wrappers, `\r`, trims lines, joins into single string.
**Affected**: `azurerm_linux_virtual_machine`, VMSS, `azurerm_ssh_public_key` → `public_key` field.
**Action**: No fix needed — provider normalizes automatically. But if generating HCL, use single-line key format.

#### Rule 7.2: RFC3339 Timestamp Equivalence

**Provider Mechanism**: `suppress.RFC3339Time` compares timestamps as instants, ignoring format.
**Action**: Use consistent format `"2024-01-01T00:00:00Z"` (UTC with Z suffix).

#### Rule 7.3: XML Policy Whitespace

**Provider Mechanism**: `suppress.XmlDiff` tokenizes XML and compares semantically.
**Affected**: APIM policies (`xml_content`), App Insights Web Tests (`configuration`).
**Action**: No fix needed for diff, but format consistently for readability.

#### Rule 7.4: List Order Independence

**Provider Mechanism**: `suppress.ListOrder` sorts both sides before comparing.
**Affected**: `azurerm_logic_app_standard` and resources migrated from TypeSet to TypeList.
**Action**: No fix needed.

---

### Category 8: Import-Breaking Provider Bugs (No Fix — Must Workaround)

#### Rule 8.1: Redis Cache Type Mismatch Crash

**Trigger**: Export crashes with `converting cty value 6 to Go: can't convert Go float64 to string`

**Root Cause**: `redis_version` is schema type `string` but state holds numeric `6` (float64). The HCL generation pipeline crashes — **no output for ANY resource in the same RG**.

**Workaround**: Exclude Redis from export: `aztfexport rg ... --query="not(type =~ 'Microsoft.Cache/Redis')"`

#### Rule 8.2: APIM Built-in Subscription Service-Scope Parse Failure

**Trigger**: `parsing scope into product/api id... ID was missing the 'apis' element`

**Root Cause**: APIM master subscription has service-scope (no API/product suffix). Provider parser expects API or product scope.

**Workaround**: Exclude from export or manage separately with azapi.

#### Rule 8.3: App Service Certificate Missing ForceNew Fields After Import

**Trigger**: Plan shows forced recreation after import of `azurerm_app_service_certificate`.

**Root Cause**: Read function doesn't restore `key_vault_secret_id`, `pfx_blob`, `password` from API. These are ForceNew → plan forces replacement.

**Workaround**: Manually set the field after import, or use `lifecycle { ignore_changes = [key_vault_secret_id] }`.

#### Rule 8.4: PIM Role Assignment Temporal Drift

**Trigger**: Plan shows forced replacement on `start_date_time` after import.

**Root Cause**: Azure PIM API returns advancing timestamps during processing. Imported value may differ from config by seconds.

**Workaround**: `lifecycle { ignore_changes = [schedule_info] }`

---

### Category 9: Application Insights Web Test Tags (aztfexport Auto-Fixed)

#### Rule 9.1: Service-Injected Tags

**Trigger**: Perpetual plan drift on `tags` field.

**Root Cause**: Azure injects additional tags after resource creation. aztfexport auto-appends `lifecycle { ignore_changes = [tags] }` for this resource type only.

**Important**: This is the ONLY resource type aztfexport applies post-processing to. All other resources with service-injected tags will show the same drift — apply the lifecycle pattern manually:
```hcl
lifecycle { ignore_changes = [tags] }
```

---

### Category 10: Subnet IPAM Pool Auto-Allocation

#### Rule 10.1: address_prefixes Filled by IPAM Pool

**Trigger**: Perpetual drift on `address_prefixes` in `azurerm_subnet` when `ip_address_pool` is configured.

**Root Cause**: When using Azure IPAM, the pool auto-allocates a CIDR range. The user never writes `address_prefixes` in config, but Azure returns the allocated CIDR. The provider has an inline DiffSuppressFunc that checks `GetRawConfig()` for `ip_address_pool`.

**Fix**: If you see drift and the subnet uses IPAM, the provider should suppress it automatically. If not (older provider), use:
```hcl
lifecycle { ignore_changes = [address_prefixes] }
```

---

### Category 11: Log Analytics System Columns

#### Rule 11.1: Custom Log Table System Columns Mixed In

**Trigger**: Plan shows additions for system columns like `TimeGenerated` in `azurerm_log_analytics_workspace_table`.

**Root Cause**: Read function returns ALL columns (user + system) without filtering. System columns appear as additions. Bug #32065 (open, no fix).

**Workaround**: Remove system columns from your config and use lifecycle ignore:
```hcl
lifecycle { ignore_changes = [column] }
```

---

## Pattern Detection Algorithm

When processing `terraform validate` or `terraform plan` errors, apply rules in this order:

```
1. Parse error message
2. Match against known patterns:
   ├─ "must be one of [...], got all"              → Rule 1.1
   ├─ "to be in the range (N - M), got 0"         → Rule 2.1
   ├─ "must be alphanumeric"                       → Rule 3.1
   ├─ "one of ... must be specified"               → Rule 4.1 / 4.2
   ├─ "all of ... must be specified"               → Rule 6.1
   ├─ "could not acquire access token"            → Clear ARM_ env vars
   ├─ "can't convert Go float64 to string"        → Rule 8.1 (exclude resource)
   ├─ "ID was missing the 'X' element"            → Rule 8.2 (composite ID)
   ├─ "no definition was found" (missing attr)    → Rule 4.2 (write-only)
   ├─ block vs attribute syntax error              → Rule 6.3
   └─ perpetual plan drift:
       ├─ on ID fields (case differs)             → Rule 1.2
       ├─ on tags (additions)                      → Rule 9.1
       ├─ on address_prefixes with IPAM           → Rule 10.1
       ├─ on timestamps (seconds differ)          → Rule 8.4
       └─ on column definitions                    → Rule 11.1
3. Apply fix
4. Re-validate / re-plan
5. If new errors, repeat from step 1
```

---

## Quick Reference: Resources With Known Import Issues

| Resource Type | Issue | Rule | Severity |
|---|---|---|---|
| `azurerm_key_vault` | "all" permissions | 1.1 | Auto-fixable |
| `azurerm_storage_container` | $account-encryption-key | 3.1 | Auto-fixable |
| `azurerm_storage_account_queue_properties` | retention_days = 0 | 2.1 | Auto-fixable |
| `azurerm_machine_learning_datastore_*` | Missing credentials | 4.1 | Needs user secret |
| `azurerm_linux_virtual_machine` | "ignored-as-imported" | 3.2 | Needs user password |
| `azurerm_windows_virtual_machine` | "ignored-as-imported" | 3.2 | Needs user password |
| `azurerm_app_service_certificate` | Missing pfx_blob | 4.2 / 8.3 | Needs user input |
| `azurerm_redis_cache` | float64→string crash | 8.1 | Must exclude |
| `azurerm_site_recovery_replicated_vm` | Block format | 6.3 | Auto-fixable |
| `azurerm_network_watcher_flow_log` | Wrong ExactlyOneOf | 6.2 | Needs manual check |
| `azurerm_monitor_diagnostic_setting` | Pipe-delimited ID | 5.2 | Import ID format |
| `azurerm_key_vault_certificate` | Needs versioned URL | 5.3 | Import ID format |
| `azurerm_application_insights_web_test` | Tag injection | 9.1 | Auto-fixable |
| `azurerm_subnet` (IPAM) | Auto-allocated CIDR | 10.1 | Auto-fixable |
| `azurerm_signalr_service` | Default bool drift | 2.2 | Auto-fixable |
| `azurerm_api_management_subscription` | Scope parse failure | 8.2 | Must exclude |
| `azurerm_log_analytics_workspace_table` | System columns | 11.1 | lifecycle ignore |

---

## Integration with Other Skills

- **brownfield-terraform-export** (`skills/brownfield-terraform-export/SKILL.md`): Calls this skill implicitly via terraform-cleanup
- **terraform-cleanup** (`skills/terraform-cleanup/SKILL.md`): Invokes rules during Phase 3 refinement
- **Standalone use**: Can be invoked directly on any raw `generated.tf`

## Category 12: Resource ID Path Segment Normalization

### Rule 12.1: `fileshares` vs `shares` in Storage File Share IDs

**Trigger**: `terraform plan` shows `forces replacement` on `storage_fileshare_id` in ML datastore resources

**Error Pattern**:
```
~ storage_fileshare_id = ".../fileServices/default/fileshares/myshare" 
                       -> ".../fileServices/default/shares/myshare" # forces replacement
```

**Root Cause**: Azure Resource Manager API returns file share resource IDs using the path segment `/fileServices/default/fileshares/{name}`. The `azurerm_storage_share` resource normalizes this to `/fileServices/default/shares/{name}`. When the imported state contains the Azure-canonical form but config references produce the provider-canonical form, the diff triggers `ForceNew` (because `storage_fileshare_id` is a ForceNew attribute).

**Affected Resources**:
- `azurerm_machine_learning_datastore_fileshare` (storage_fileshare_id)
- Any resource that references `azurerm_storage_share.*.id` in a ForceNew field

**Fix**:
```hcl
resource "azurerm_machine_learning_datastore_fileshare" "example" {
  # ... other attributes ...
  storage_fileshare_id = azurerm_storage_share.example.id
  
  lifecycle {
    ignore_changes = [storage_fileshare_id]
  }
}
```

**Alternative Fix** (if not using references): Replace `fileshares` with `shares` in the hardcoded ID string.

**Plan Impact After Fix**: Change disappears entirely (lifecycle ignore). The resource remains correctly managed.

**Discovery**: Found during E2E skill test 2026-05-04 against rg-anuj-parashar. 4 ML fileshare datastores all showed forced replacement until lifecycle ignore applied.

---

## Category 13: Post-Export Hygiene (Orphaned Artifacts)

### Rule 13.1: Orphaned Import Blocks for Failed Resources

**Trigger**: `terraform plan` shows "Configuration for import target does not exist" errors

**Error Pattern**:
```
Error: Configuration for import target does not exist
  on import.tf line XX, in import:
  XX:   to = azurerm_key_vault_secret.res-5
```

**Root Cause**: When `aztfexport --continue` encounters an import failure (e.g., 403 on KV secrets), it skips the resource's HCL generation but STILL writes the import block. This creates orphaned import blocks pointing to non-existent config targets.

**Detection**: Cross-reference `aztfexportSkippedResources.txt` (or stderr 403/500 errors) against `import.tf` blocks. Any `to = X` target that has no corresponding `resource "..." "X"` in main.tf is orphaned.

**Fix**: Remove the entire `import { }` block for each orphaned target.

**Automated Detection Algorithm**:
1. Parse all `to = <type>.<name>` from import.tf
2. Parse all `resource "<type>" "<name>"` from *.tf (excluding import.tf)
3. Any target in (1) not in (2) → remove that import block

### Rule 13.2: Leaked Credentials in provider.tf

**Trigger**: `terraform plan` fails with "Invalid client secret" or provider auth errors

**Error Pattern**:
```
Error: building account: could not acquire access token to parse claims: 
clientCredentialsToken: received HTTP status 401
```

**Root Cause**: `aztfexport` reads `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_TENANT_ID`, `ARM_SUBSCRIPTION_ID` from environment and bakes them into `provider.tf` as explicit `client_id`, `client_secret`, `tenant_id` attributes. If these credentials are stale/rotated, plan fails. Even if valid, this is a **security leak** (secrets in code).

**Fix**: Strip ALL of these from provider.tf:
- `client_id`
- `client_secret`  
- `tenant_id` (optional — only remove if using CLI auth)
- `use_cli`, `use_oidc`, `use_msi`, `environment` (remove defaults)

**Minimal Safe provider.tf**:
```hcl
provider "azurerm" {
  features {}
  subscription_id                 = "your-sub-id"
  resource_provider_registrations = "none"
}
```

**Note**: This is a security AND functionality fix. Should be applied BEFORE terraform validate (Phase 0 of terraform-cleanup).

---

## Contributing New Rules

When a new translation mismatch is discovered:

1. Document the **trigger** (exact error message pattern)
2. Document the **root cause** (why Azure returns X but provider expects Y)
3. Document the **affected resources** (which resource types hit this)
4. Document the **fix** (exact HCL transformation)
5. Document the **plan impact** (what the plan shows after fix)
6. Add to the pattern detection algorithm
7. Add to the quick reference table
8. Test against a real resource group to validate

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.1 | 2026-05-04 | Added Category 12 (fileshares/shares path normalization) and Category 13 (orphaned import blocks, leaked credentials in provider.tf). All from E2E retest. |
| 2.0 | 2026-05-04 | Major expansion — 30+ rules across 11 categories. Sourced from azurerm provider DiffSuppressFunc analysis (89 usages), aztfexport known issues (16 patterns), aztfmigrate TuneHCL logic, and GitHub issues. Added quick reference table. |
| 1.0 | 2026-05-04 | Initial release — 7 rules across 7 categories from rg-anuj-parashar brownfield conversion |
