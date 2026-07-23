# Terraform cleanup reference patterns

Patterns captured from live brownfield conversions. The orchestrator and sub-skills cite
this file; it is not loaded by default.

## Permission Enum Shorthand

Azure KV API returns `"all"` for permissions; azurerm requires the explicit enum list.
See translation skill Rule 1.1 for the full enum lists.

## Conditional Write-Only Properties

`account_key` is required only when `service_data_auth_identity = "None"`. Check the auth
mode before asking the user for the secret.

## Cross-Resource ID Format Mismatch

`azurerm_storage_share.id` uses `/shares/` but ML datastores expect `/fileshares/`. Use
string interpolation:

```hcl
file_system = "${replace(azurerm_storage_share.demo.id, "/shares/", "/fileshares/")}"
```

Add `lifecycle { ignore_changes = [file_system] }` since the URL drift is cosmetic.

## Partial Export Success

aztfexport may fail on some resources but `terraform plan -generate-config-out` still
works for the rest. Use `--continue` and process the survivors.

## Provider Default Materialization

The provider may inject documented defaults during plan even when the live resource
has the field null (e.g. `ip_restriction_default_action`). Settle by setting the value
explicitly in config; one apply absorbs it.

## Saved Search Auto-Creation

A Log Analytics workspace auto-creates ~39 saved searches. Don't delete them —
consolidate with `cleanup-consolidate` into one `for_each` block (39 → 1).

## Iteration Metrics

| Metric | Without doc-fetch | With doc-fetch |
|---|---|---|
| Plan iterations to zero-destroy | ~5 | ~1–2 |
| Unique error categories | ~3 | ~0–1 |
| Time to convergence | ~15 min | ~5 min |
