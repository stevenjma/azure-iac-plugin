# Translation diagnostics and rule index

Load this reference only when the error or plan hunk does not map directly to a rule file in
`SKILL.md`, or when the affected resource type is known but the symptom is not.

## Pattern Detection Algorithm

When processing `terraform validate` or `terraform plan` errors, apply rules in this order:

```text
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

- **brownfield-iac-export**: Routes exported Terraform through `terraform-cleanup`.
- **terraform-cleanup**: Invokes this skill during Phase 3 refinement.
- **Standalone use**: Can be invoked directly on any raw `generated.tf`

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
