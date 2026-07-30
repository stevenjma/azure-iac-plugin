# azure-iac-plugin

Export existing Azure infrastructure into production-quality **Bicep or Terraform**.

A brownfield Infrastructure-as-Code toolkit that adopts already-deployed Azure resources into
clean IaC using the **ARM control-plane export APIs** (`exportTemplate` / `exportTerraform`) as the
export engine — no local `aztfexport` install required. Exports are refined through an
**evidence-gated cleanup** pipeline and checked with **symmetric syntax + fidelity validation**
(`terraform plan` / ARM what-if), so Bicep and Terraform reach the same bar.

## What this is (and what it runs on)

This is a portable bundle of two client-agnostic pieces:

- **Skills** — Markdown playbooks under `skills/` (`SKILL.md` each). Any agent that can read and
  follow skill/instruction files can use them.
- **MCP config** — a `.mcp.json` registering a remote **ARM MCP server** for read/query and the
  Bicep what-if fidelity gate.

Because both pieces are standard formats, **any MCP-capable agent client can host this** — GitHub
Copilot CLI is the primary/reference client, but it is deliberately *not* the only one. See
[Clients](#clients).

> **POC status.** This is a proof of concept. The export path defaults to direct authenticated ARM
> REST (via `az rest`) behind a single swappable `export-dispatch` seam that upgrades to first-class
> ARM MCP tools as they ship.

## How it works

```
intake (scope + language)
        │
        ▼
brownfield-iac-export  ──terraform──►  exportTerraform  ─► HCL + import blocks ─► terraform-cleanup ─► cleanup-validate
        │                                                                                              (terraform validate + plan)
        └──────────bicep────────────►  exportTemplate   ─► ARM JSON ─► bicep decompile ─► bicep-cleanup ─► bicep-validate
                                                                                                          (bicep build/lint + what-if)
```

Every cleanup pass writes a JSON artifact to `<workdir>/.cleanup/`. Validation refuses to run
unless every required upstream artifact reports `status: "complete"` — this is the crown-jewel
gating that defeats "looks done, isn't done." Validation is two-tier and **symmetric**:

| | Syntax gate | Fidelity / gap gate |
|---|---|---|
| Terraform | `terraform validate` | `terraform plan` — a faithful brownfield import yields a ~empty plan |
| Bicep | `az bicep build` / `az bicep lint` | ARM what-if (`whatif_deployment`, or `az deployment group what-if`) — "no changes" = faithful |

The what-if / plan diff is a single comparable **gap score** and the primary Bicep↔Terraform
parity signal.

## Prerequisites

- **`az` CLI**, authenticated (`az login`) to the target subscription — used for `az rest` export
  and `az deployment group what-if`.
- **`bicep` CLI** (`az bicep install`) — for `bicep decompile` / `bicep build` / `az bicep lint`.
- **`terraform`** ≥ 1.5 (import blocks); ≥ 1.10 for ephemeral variables.
- **No `aztfexport`** — export is service-side.

## Configuration

The remote ARM MCP server is configured entirely by environment variables (nothing secret is
committed):

| Env var | Purpose |
|---|---|
| `ARM_MCP_URL` | Remote ARM MCP endpoint (used in `.mcp.json`) |
| `ARM_MCP_TOKEN` | Bearer token for the `Authorization` header |

**No hard dependency on the remote ARM MCP.** If `arm-mcp` is not wired up:

- Export falls back to direct ARM REST via `az rest`.
- The Bicep fidelity gate falls back to `az deployment group what-if`.
- Terraform's fidelity gate (`terraform plan`) is pure local CLI and never needs the MCP.

Configure `arm-mcp` for the governed control-plane path, but the pipeline never blocks on it.

## Clients

### GitHub Copilot CLI (reference client)

```bash
# from the monorepo root
copilot plugin install ./azure-iac-skills
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
   files via your client's skills/instructions mechanism). Start from `brownfield-iac-export`,
   which performs intake and routes to the language-specific cleanup + validate skills.

`.github/copilot-instructions.md` is the Copilot-CLI-flavored system prompt; other clients can use
it as-is as a reference for identity, routing, and prerequisites.

## Agent Skills conformance

The skill layout follows the official [Agent Skills specification](https://github.com/agentskills/agentskills/blob/main/docs/specification.mdx)
and [authoring guidance](https://github.com/agentskills/agentskills/blob/main/docs/skill-creation/best-practices.mdx):

- Every `SKILL.md` stays below 500 lines; detailed rule libraries and command examples live under
  `references/` and are loaded only for a matching diagnostic or execution step.
- Skill names use lowercase hyphenated identifiers and match their directory names.

Use the official [`skills-ref`](https://github.com/agentskills/agentskills/tree/main/skills-ref)
validator after changing skill metadata:

```powershell
Get-ChildItem .\skills -Directory | ForEach-Object {
  skills-ref validate $_.FullName
}
```

## Skill map

| Skill | Role |
|---|---|
| `brownfield-iac-export` | Entry point — intake, language selection, export dispatch |
| `terraform-cleanup` | Terraform cleanup orchestrator (gated pipeline) |
| `cleanup-references`, `cleanup-variables`, `cleanup-prune`, `cleanup-consolidate`, `cleanup-organize`, `cleanup-secrets` | Terraform cleanup passes |
| `cleanup-validate` | Terraform gated validate (`terraform validate` + `plan`) |
| `azure-to-terraform-translation` | Terraform drift-rule library (30+ rules) |
| `bicep-cleanup` | Bicep cleanup orchestrator (gated, leaner) |
| `bicep-parameterize`, `bicep-prune`, `bicep-organize`, `bicep-secrets` | Bicep cleanup passes |
| `bicep-validate` | Bicep gated validate (`bicep build`/lint + what-if) |
| `azure-to-bicep-translation` | Bicep decompile drift-rule library |

## Non-goals

- **Never applies.** No `terraform apply`, no `az deployment group create`. You export, plan,
  validate, and generate — the human applies.
- **Never installs tools silently** or fabricates resource configurations.
