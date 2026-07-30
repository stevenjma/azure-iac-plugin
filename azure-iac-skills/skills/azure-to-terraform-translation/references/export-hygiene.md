# Post-export hygiene rules

Load this reference immediately after export when import blocks or provider configuration prevent
validation from starting.

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
