# Provider bugs and service-generated drift

Load this reference for provider import failures, forced replacements, service-generated tags,
IPAM allocation, and system properties that cannot be represented faithfully.

## Category 8: Import-Breaking Provider Bugs (No Fix — Must Workaround)

### Rule 8.1: Redis Cache Type Mismatch Crash

**Trigger**: Export crashes with `converting cty value 6 to Go: can't convert Go float64 to string`

**Root Cause**: `redis_version` is schema type `string` but state holds numeric `6` (float64). The HCL generation pipeline crashes — **no output for ANY resource in the same RG**.

**Workaround**: Exclude Redis from export: `aztfexport rg ... --query="not(type =~ 'Microsoft.Cache/Redis')"`

### Rule 8.2: APIM Built-in Subscription Service-Scope Parse Failure

**Trigger**: `parsing scope into product/api id... ID was missing the 'apis' element`

**Root Cause**: APIM master subscription has service-scope (no API/product suffix). Provider parser expects API or product scope.

**Workaround**: Exclude from export or manage separately with azapi.

### Rule 8.3: App Service Certificate Missing ForceNew Fields After Import

**Trigger**: Plan shows forced recreation after import of `azurerm_app_service_certificate`.

**Root Cause**: Read function doesn't restore `key_vault_secret_id`, `pfx_blob`, `password` from API. These are ForceNew → plan forces replacement.

**Workaround**: Manually set the field after import, or use `lifecycle { ignore_changes = [key_vault_secret_id] }`.

### Rule 8.4: PIM Role Assignment Temporal Drift

**Trigger**: Plan shows forced replacement on `start_date_time` after import.

**Root Cause**: Azure PIM API returns advancing timestamps during processing. Imported value may differ from config by seconds.

**Workaround**: `lifecycle { ignore_changes = [schedule_info] }`

---

## Category 9: Application Insights Web Test Tags (aztfexport Auto-Fixed)

### Rule 9.1: Service-Injected Tags

**Trigger**: Perpetual plan drift on `tags` field.

**Root Cause**: Azure injects additional tags after resource creation. aztfexport auto-appends `lifecycle { ignore_changes = [tags] }` for this resource type only.

**Important**: This is the ONLY resource type aztfexport applies post-processing to. All other resources with service-injected tags will show the same drift — apply the lifecycle pattern manually:
```hcl
lifecycle { ignore_changes = [tags] }
```

---

## Category 10: Subnet IPAM Pool Auto-Allocation

### Rule 10.1: address_prefixes Filled by IPAM Pool

**Trigger**: Perpetual drift on `address_prefixes` in `azurerm_subnet` when `ip_address_pool` is configured.

**Root Cause**: When using Azure IPAM, the pool auto-allocates a CIDR range. The user never writes `address_prefixes` in config, but Azure returns the allocated CIDR. The provider has an inline DiffSuppressFunc that checks `GetRawConfig()` for `ip_address_pool`.

**Fix**: If you see drift and the subnet uses IPAM, the provider should suppress it automatically. If not (older provider), use:
```hcl
lifecycle { ignore_changes = [address_prefixes] }
```

---

## Category 11: Log Analytics System Columns

### Rule 11.1: Custom Log Table System Columns Mixed In

**Trigger**: Plan shows additions for system columns like `TimeGenerated` in `azurerm_log_analytics_workspace_table`.

**Root Cause**: Read function returns ALL columns (user + system) without filtering. System columns appear as additions. Bug #32065 (open, no fix).

**Workaround**: Remove system columns from your config and use lifecycle ignore:
```hcl
lifecycle { ignore_changes = [column] }
```
