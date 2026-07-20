# azure-avm-plugin

Adopt existing Azure infrastructure into production-quality **Bicep or Terraform composed of
Azure Verified Modules (AVM)**.

A brownfield-to-AVM Infrastructure-as-Code toolkit. Instead of emitting raw `resource` blocks, it
**re-expresses** already-deployed Azure resources as calls to published AVM registry modules
(`br/public:avm/res/...` for Bicep, `Azure/avm-res-*/azurerm` for Terraform). The ARM control-plane
export APIs (`exportTemplate` / `exportTerraform`) are used only as a **configuration oracle** to
harvest live property values; those values are then wired into module inputs. Compositions are
refined through an **evidence-gated pipeline** and checked with **symmetric syntax + fidelity
validation** (`terraform plan` / ARM what-if), so Bicep and Terraform reach the same bar.

Module names, statuses, and versions are grounded in the AVM index — **https://aka.ms/avm**.

## Why AVM instead of raw resources?

This plugin is the **AVM-first counterpart** to a raw-export brownfield toolkit. The difference is
the output unit and everything that follows from it:

| | Raw-export approach | This plugin (AVM-first) |
|---|---|---|
| Output unit | raw `resource` blocks | AVM **module** calls with wired inputs |
| Role of the export API | produces the final code | **oracle** — harvests live config only |
| Core cleanup problem | prune computed/default props off the export | **map live config → module inputs** (the module owns the rest) |
| Security posture | whatever was deployed | WAF-aligned AVM defaults, adopt-or-pin per input |
| Validation goal | faithful no-op plan/what-if | faithful **or** a deliberate posture uplift (reconciliation ledger) |
| New first-class concern | — | **coverage / gaps** (types with no usable module) |

You get less generated code, built-in Well-Architected defaults, and modules the AVM program keeps
patched — at the cost of a resolve step and a reconciliation decision, both of which this plugin
makes explicit and evidence-gated.

## What this is (and what it runs on)

This is a portable bundle of two client-agnostic pieces:

- **Skills** — Markdown playbooks under `skills/` (`SKILL.md` each). Any agent that can read and
  follow skill/instruction files can use them.
- **MCP config** — a `.mcp.json` registering a remote **ARM MCP server** for Azure Resource Graph
  discovery and the Bicep what-if fidelity gate.

Because both pieces are standard formats, **any MCP-capable agent client can host this** — GitHub
Copilot CLI is the primary/reference client, but it is deliberately *not* the only one. See
[Clients](#clients).

> **POC status.** This is a proof of concept. The harvest oracle defaults to direct authenticated
> ARM REST (via `az rest`) behind a single swappable `export-dispatch` seam that upgrades to
> first-class ARM MCP tools as they ship. Module resolution reads the public AVM index + MCR /
> Terraform Registry version feeds.

## How it works

```
intake (scope + language)
        │
        ▼
brownfield-avm-adopt ──► discover (ARG)  ──►  harvest config (export oracle)
        │                                            │
        │                                            ▼
        │                                   avm-module-resolver  (type → AVM module + pinned version + status)
        │                                            │
        ├──terraform──►  terraform-avm-compose ─► map ─► inputs (reconcile) ─► organize ─► secrets ─► terraform-avm-validate
        │                                                                                            (terraform validate + plan)
        └──bicep──────►  bicep-avm-compose     ─► map ─► inputs (reconcile) ─► organize ─► secrets ─► bicep-avm-validate
                                                                                                     (bicep build/lint + what-if)
```

Every pass writes a JSON artifact to `<workdir>/.avm/`. Validation refuses to run unless every
required upstream artifact reports `status: "complete"` — the gating that defeats "looks done,
isn't done." Two extra artifacts are unique to the AVM lane:

- **`coverage.json`** — per-type resolution: module, pinned version, status (Available / Orphaned /
  Proposed / none), or `fallback` with a reason. Coverage % is a headline output.
- **`reconciliation.json`** — every input where an AVM default differed from live state, and the
  human's per-input decision: `adopt` (take the AVM/WAF posture) or `pin` (match current state).

Validation is two-tier and **symmetric**:

| | Syntax gate | Fidelity / gap gate |
|---|---|---|
| Terraform | `terraform validate` (after `terraform init` restores modules) | `terraform plan` — pinned inputs yield a ~empty plan; adopted defaults appear as intended changes |
| Bicep | `az bicep build` / `az bicep lint` (after `bicep restore`) | ARM what-if (`whatif_deployment`, or `az deployment group what-if`) — deltas cross-checked against the reconciliation ledger |

The what-if / plan diff is a single comparable **gap score**; every non-empty line must map to a
`reconciliation.json` entry marked `adopt`, or it is a real defect.

## Prerequisites

- **`az` CLI**, authenticated (`az login`) to the target subscription — ARG discovery, `az rest`
  harvest, and `az deployment group what-if`.
- **`bicep` CLI** (`az bicep install`) — for `bicep restore` / `bicep build` / `az bicep lint` of
  `br/public` modules.
- **`terraform`** ≥ 1.5 (module + import blocks); ≥ 1.10 for ephemeral variables.
- **Network egress** to `mcr.microsoft.com` (Bicep module versions + restore) and the Terraform
  Registry (`azurerm` module versions + `terraform init`).
- **No `aztfexport`** — discovery + harvest are service-side.

## Configuration

The remote ARM MCP server is configured entirely by environment variables (nothing secret is
committed):

| Env var | Purpose |
|---|---|
| `ARM_MCP_URL` | Remote ARM MCP endpoint (used in `.mcp.json`) |
| `ARM_MCP_TOKEN` | ****** for the `Authorization` header |

**No hard dependency on the remote ARM MCP.** If `arm-mcp` is not wired up:

- Discovery falls back to `az graph query` / `az resource list`.
- The harvest oracle falls back to direct ARM REST via `az rest`.
- The Bicep fidelity gate falls back to `az deployment group what-if`.
- Terraform's fidelity gate (`terraform plan`) is pure local CLI and never needs the MCP.

Configure `arm-mcp` for the governed control-plane path, but the pipeline never blocks on it.

## Clients

### GitHub Copilot CLI (reference client)

```bash
# from the repo's parent directory
copilot plugin install ./azure-avm-plugin
```

Verify with `/skills`. Skill components are cached at install time — reinstall after editing
anything under `skills/`, `.mcp.json`, or `plugin.json`.

### Any other MCP-capable client

The skills and MCP config are portable. To use them elsewhere:

1. **Register the MCP server** — copy the `arm-mcp` entry from `.mcp.json` into your client's MCP
   configuration (Claude Code `.mcp.json`, VS Code `mcp.json`, Cursor, etc.), setting `ARM_MCP_URL`
   / `ARM_MCP_TOKEN` in the environment. If your client can't reach a remote ARM MCP, skip this —
   the CLI fallbacks above keep everything working.
2. **Make the skills discoverable** — point your agent at `skills/` (or import the `SKILL.md`
   files via your client's skills/instructions mechanism). Start from `brownfield-avm-adopt`,
   which performs intake and routes to the language-specific compose + validate skills.

`.github/copilot-instructions.md` is the Copilot-CLI-flavored system prompt; other clients can use
it as-is as a reference for identity, routing, and prerequisites.

## Skill map

| Skill | Role |
|---|---|
| `brownfield-avm-adopt` | Entry point — intake, language selection, discovery + config harvest, dispatch |
| `avm-module-resolver` | Core engine — resource type → AVM module (source, pinned version, status, gaps) |
| `bicep-avm-compose` | Bicep composition orchestrator (gated pipeline) |
| `bicep-avm-map`, `bicep-avm-inputs`, `bicep-avm-organize`, `bicep-avm-secrets` | Bicep composition passes |
| `bicep-avm-validate` | Bicep gated validate (`bicep build`/lint + what-if, reconciliation-aware) |
| `terraform-avm-compose` | Terraform composition orchestrator (gated pipeline) |
| `terraform-avm-map`, `terraform-avm-inputs`, `terraform-avm-organize`, `terraform-avm-secrets` | Terraform composition passes |
| `terraform-avm-validate` | Terraform gated validate (`terraform validate` + `plan`, reconciliation-aware) |

## Non-goals

- **Never applies.** No `terraform apply`, no `az deployment group create`. You compose, plan,
  validate, and generate — the human applies.
- **Never floats `latest`.** Every module reference is pinned to an explicit version.
- **Never silently reconciles.** Every AVM-default-vs-live difference is a surfaced, recorded
  adopt-or-pin decision.
- **Never installs tools silently** or fabricates module inputs.
