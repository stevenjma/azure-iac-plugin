# Resource ID and structural rules

Load this reference for composite or noncanonical resource IDs, schema shape mismatches, nested
block rendering, child-resource representation, and provider-normalized formatting.

## Category 5: Cross-Resource ID Format Mismatches

### Rule 5.1: Storage `/shares/` vs `/fileshares/` Segment

**Trigger**: Perpetual drift on `storage_fileshare_id`.

**Root Cause**: `azurerm_storage_share.id` uses `/shares/` but ML datastores expect `/fileshares/`.

**Fix**: Use interpolation or lifecycle ignore:
```hcl
storage_fileshare_id = "${azurerm_storage_account.example.id}/fileServices/default/fileshares/${azurerm_storage_share.example.name}"
```

### Rule 5.2: Monitor Diagnostic Setting Pipe-Delimited IDs

**Trigger**: Import fails or produces wrong resource associations.

**Root Cause**: `azurerm_monitor_diagnostic_setting` uses composite IDs: `<target_id>|<setting_name>`. `azurerm_role_definition` uses `<role_id>|<scope>`. These pipe-delimited formats don't match Azure ARM resource IDs.

**Fix**: When importing these resources, ensure the import ID uses the pipe-delimited format:
```hcl
import {
  to = azurerm_monitor_diagnostic_setting.example
  id = "/subscriptions/.../resourceGroups/.../providers/.../myResource|myDiagSetting"
}
```

### Rule 5.3: Key Vault Certificate Requires Versioned Import ID

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

## Category 6: Structural / Schema Mismatches

### Rule 6.1: Co-Dependent Attributes (encryption_scope)

**Trigger**: `all of 'default_encryption_scope,encryption_scope_override_enabled' must be specified`

**Fix**: Provide both or remove both. See Rule 3.1 in `value-normalization.md`.

### Rule 6.2: ExactlyOneOf Alphabetical Selection

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

### Rule 6.3: Block vs. Attribute Format (TypeList rendering)

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

### Rule 6.4: Inline vs. Standalone Child Resources

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

## Category 7: Format Normalization (Provider Handles Automatically)

These are patterns the provider handles via DiffSuppressFunc. You generally don't need to fix these manually, but be aware they exist:

### Rule 7.1: SSH Key Whitespace/Line Endings

**Provider Mechanism**: `suppress.SSHKey` strips heredoc wrappers, `\r`, trims lines, joins into single string.
**Affected**: `azurerm_linux_virtual_machine`, VMSS, `azurerm_ssh_public_key` → `public_key` field.
**Action**: No fix needed — provider normalizes automatically. But if generating HCL, use single-line key format.

### Rule 7.2: RFC3339 Timestamp Equivalence

**Provider Mechanism**: `suppress.RFC3339Time` compares timestamps as instants, ignoring format.
**Action**: Use consistent format `"2024-01-01T00:00:00Z"` (UTC with Z suffix).

### Rule 7.3: XML Policy Whitespace

**Provider Mechanism**: `suppress.XmlDiff` tokenizes XML and compares semantically.
**Affected**: APIM policies (`xml_content`), App Insights Web Tests (`configuration`).
**Action**: No fix needed for diff, but format consistently for readability.

### Rule 7.4: List Order Independence

**Provider Mechanism**: `suppress.ListOrder` sorts both sides before comparing.
**Affected**: `azurerm_logic_app_standard` and resources migrated from TypeSet to TypeList.
**Action**: No fix needed.

---

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
