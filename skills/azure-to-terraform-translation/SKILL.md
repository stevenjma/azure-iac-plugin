---
name: azure-to-terraform-translation
description: >
  Use this skill when imported or Azure-exported Terraform fails validate or plan, shows perpetual
  drift, rejects enum or sentinel values, mishandles resource IDs, or exposes provider/export bugs.
  Diagnose Azure API-to-azurerm/azapi translation mismatches without changing unrelated resources.
license: MIT
metadata:
  version: "1.2"
  author: Stephen Ma
---

# Azure-to-Terraform translation

Diagnose the smallest provider/API mismatch that explains the observed error or drift, apply only
the matching rule, then re-run the same validation or plan command. Do not load the full rule
library preemptively.

## Use this skill when

- `terraform validate` or `terraform plan` fails after import or Azure control-plane export.
- Provider validation rejects a value returned by Azure.
- A plan shows perpetual drift or replacement despite no intended live change.
- Export output contains orphan imports, leaked provider credentials, or unsupported resources.

The `terraform-cleanup` orchestrator may invoke this skill during refinement. It can also run
standalone against existing imported HCL.

## Diagnostic workflow

1. Capture the exact validation error or smallest relevant plan hunk.
2. Identify the attribute and Terraform resource type.
3. Match the symptom in the index below.
4. Load only the matching reference file from the index below.
5. Confirm current behavior with the matching provider schema or documentation when the rule
   depends on an enum, default, computed field, write-only field, or provider version.
6. Apply the narrowest fix. Prefer resource references and omission of invalid optional values over
   broad `ignore_changes`.
7. Run `terraform fmt`, `terraform validate`, and the same read-only `terraform plan`.
8. Repeat only for newly surfaced errors. Never run `terraform apply`.

## Rule index

| Symptom | Load |
|---|---|
| Invalid enum, case-only ID drift, empty-string enum | `references/value-normalization.md` |
| Zero sentinel or provider-materialized default | `references/value-normalization.md` |
| Invalid Azure sentinel value | `references/value-normalization.md` |
| Missing secret or write-only property | `references/value-normalization.md` |
| Cross-resource or composite ID mismatch | `references/ids-and-structure.md` |
| ExactlyOneOf, block/attribute, or child-resource shape mismatch | `references/ids-and-structure.md` |
| Provider-normalized formatting with no semantic change | `references/ids-and-structure.md` |
| Import/export crash or provider bug requiring exclusion/workaround | `references/provider-bugs-and-drift.md` |
| Service-injected tags, IPAM allocation, or system-column drift | `references/provider-bugs-and-drift.md` |
| Orphan import blocks or credentials in generated provider config | `references/export-hygiene.md` |

Load `references/diagnostics.md` when the symptom is ambiguous or the resource type is known but the
matching rule is not.

## Guardrails

- Treat the live Azure resource and provider/ARM documentation as evidence; never invent values.
- Preserve the user's chosen provider (`azurerm` or `azapi`).
- Never hardcode subscription IDs, credentials, or write-only secrets.
- Do not accept resource replacement as harmless without explicit user approval.
- Use `ignore_changes` only for provider/API normalization that cannot be represented faithfully.
- Report exclusions and manual secret requirements; do not hide degraded management coverage.

## References

- `references/value-normalization.md` — Rules 1-4: enums, sentinels, defaults, and write-only fields.
- `references/ids-and-structure.md` — Rules 5-7 and 12: IDs, schema shape, and normalization.
- `references/provider-bugs-and-drift.md` — Rules 8-11: provider bugs and service-generated drift.
- `references/export-hygiene.md` — Rule 13: orphan imports and generated provider credentials.
- `references/diagnostics.md` — pattern detection, resource quick reference, and rule maintenance.
