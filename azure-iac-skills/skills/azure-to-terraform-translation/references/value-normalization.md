# Value normalization and write-only rules

Load this reference for invalid enums, case differences, sentinel values, defaults, secrets, and
write-only fields. Confirm enum values, defaults, and field behavior with the matching provider
schema before applying a rule.

## Category 1: Enum & Case Normalization

### Rule 1.1: Key Vault "all" Permissions Shorthand

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

### Rule 1.2: Resource ID Case Inconsistency (89+ resources)

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

### Rule 1.3: NSG Protocol Enum Case

**Trigger**: Plan drift on `protocol` field in `azurerm_network_security_rule`.

**Root Cause**: Azure returns `"tcp"` or `"TCP"` but provider ValidateFunc expects `"Tcp"`. The provider normalizes in Read via a protocol map (issue #16092).

**Fix**: Ensure protocol values use title case: `"Tcp"`, `"Udp"`, `"Icmp"`, `"Esp"`, `"Ah"`, `"*"`.

### Rule 1.4: Location String Normalization

**Trigger**: Plan shows location change (e.g., `"East US"` → `"eastus"`).

**Root Cause**: Azure returns display names (`"East US"`) or canonical (`"eastus"`) depending on API version. Provider normalizes via `location.Normalize()` (lowercase, no spaces).

**Fix**: Always use canonical form: `"eastus"`, `"westeurope"`, `"australiaeast"`. The provider handles this automatically in Read, so this rarely manifests after first plan.

### Rule 1.5: Key Vault Versioned vs. Versionless URL

**Trigger**: Plan drift on `key_vault_secret_id` showing version GUID appended.

**Root Cause**: User writes versionless URL (`https://vault.vault.azure.net/secrets/name`), Azure returns versioned (`https://vault.vault.azure.net/secrets/name/abc123`). Provider suppresses via `DiffSuppressIgnoreKeyVaultKeyVersion`.

**Affected**: `azurerm_app_service_certificate.key_vault_secret_id`, and any field referencing KV items.

**Fix**: Use versionless URLs in config. The provider suppresses the version diff. For `azurerm_key_vault_certificate` import: you MUST provide the versioned URL (it requires `VersionTypeVersioned`).

### Rule 1.6: Empty-String Enum Attributes (aztfexport artifact)

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

## Category 2: Out-of-Range Sentinel Values

### Rule 2.1: Zero-Value Retention Days

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

### Rule 2.2: Default Boolean Fields Not Marked Computed

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

## Category 3: Invalid/Sentinel Attribute Values

### Rule 3.1: Storage Encryption Scope "$account-encryption-key"

**Trigger**: `storage encryption scope name "$account-encryption-key" must be alphanumeric`

**Root Cause**: Azure returns internal sentinel `$account-encryption-key` for account-level default. Contains `$` and `-` = invalid.

**Fix**: Remove both `default_encryption_scope` AND `encryption_scope_override_enabled` (co-dependent):
```hcl
# Remove both — account default encryption is implicit behavior
```

### Rule 3.2: VM Admin Password "ignored-as-imported" Sentinel

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

## Category 4: Secrets & Write-Only Fields

### Rule 4.1: ML Datastore Credentials

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

### Rule 4.2: Generic Write-Only Properties (No API GET Return)

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

### Rule 4.3: Invalid Attribute Name "service_data_identity"

**Trigger**: Validation error or silent drift on fileshare datastores.

**Root Cause**: Generated HCL uses `service_data_identity` (wrong) instead of `service_data_auth_identity` (correct).

**Fix**: Remove the invalid attribute entirely. Auth handled by Rule 4.1.
