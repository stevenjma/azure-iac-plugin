# azure-iac-plugin

Two complementary **brownfield-to-Infrastructure-as-Code export methods** for Azure, hosted
side-by-side in one monorepo — one plugin per subfolder. Both adopt already-deployed Azure
resources into production-quality **Bicep or Terraform**, using the ARM control-plane export APIs
(`exportTemplate` / `exportTerraform`) and symmetric syntax + fidelity validation
(`terraform plan` / ARM what-if). They differ in **what they emit** and **what role the export API
plays**.

| Plugin | Method | Output unit | Role of the export API |
|---|---|---|---|
| [`azure-iac-skills/`](./azure-iac-skills/) | **Raw export** | raw `resource` blocks | **produces the final code** |
| [`azure-avm-skills/`](./azure-avm-skills/) | **AVM-module export** | Azure Verified Module (AVM) calls with wired inputs | **oracle only** — harvests live config |

## Comparison

| | Raw export — [`azure-iac-skills`](./azure-iac-skills/) | AVM-module export — [`azure-avm-skills`](./azure-avm-skills/) |
|---|---|---|
| **Output unit** | Raw `resource` blocks emitted directly from the export | AVM **module** calls (`br/public:avm/res/...` for Bicep, `Azure/avm-res-*/azurerm` for Terraform) |
| **Role of the export API** | Produces the final IaC code (`exportTemplate` / `exportTerraform` is the export engine) | **Configuration oracle only** — harvests live property values, which are then wired into module inputs |
| **Core cleanup problem** | Prune computed/default props off the raw export | Map live config → module inputs (the module owns the rest) |
| **Security posture** | Whatever was deployed | WAF-aligned AVM defaults; adopt-or-pin per input |
| **Validation goal** | Faithful no-op `plan` / what-if | Faithful no-op **or** a deliberate posture uplift (reconciliation ledger) + AVM coverage reporting |
| **When to use** | You want a faithful 1:1 capture of existing infra, minimal abstraction, or types with no AVM module | You want less generated code, Well-Architected defaults, and modules the AVM program keeps patched |

Both methods share the same foundations: an evidence-gated cleanup/composition pipeline (each pass
writes a JSON artifact and validation refuses to run until upstream artifacts report
`status: "complete"`), a swappable `export-dispatch` seam over authenticated ARM REST, and symmetric
Bicep↔Terraform fidelity gates.

## Plugins

- **[`azure-iac-skills/`](./azure-iac-skills/)** — RAW Bicep/Terraform export. Emits raw resource
  blocks via ARM `exportTemplate` / `exportTerraform`, refined through evidence-gated cleanup and
  checked with `terraform plan` / ARM what-if. See its
  [README](./azure-iac-skills/README.md).
- **[`azure-avm-skills/`](./azure-avm-skills/)** — AVM-module export. Re-expresses resources as
  Azure Verified Module calls, using the export API only as a config oracle, with a
  resource-type-to-module resolver, AVM-default reconciliation, and coverage reporting. See its
  [README](./azure-avm-skills/README.md).

## Repository layout

```
/README.md              this file
/azure-iac-skills/      raw-export plugin (plugin.json, .mcp.json, .github/, skills/, test-evidence/)
/azure-avm-skills/      AVM-module-export plugin (plugin.json, .mcp.json, .github/, skills/, test-evidence/)
```

Each subfolder is a self-contained plugin: its `plugin.json` references `skills/` and `.mcp.json`
relative to that subfolder, so the two plugins install and run independently.

> **POC status.** Both plugins are proofs of concept. The export/harvest action calls the ARM
> control-plane REST API directly (via `az rest`) behind a single `export-dispatch` seam. A remote
> ARM MCP server, when wired, serves the read/query (ARG) and Bicep what-if operations it exposes.
