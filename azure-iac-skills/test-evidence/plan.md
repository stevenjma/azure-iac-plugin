# PR #1 Live Test — `azure-iac-skills` (brownfield IaC export)

## Goal
Run the **same style of live end-to-end test** I ran on PR #2, but against **PR #1**
(`azure-iac-skills`, branch `stevenjma-arm-mcp-iac-plan`). PR #1 is a *different* plugin:
it **exports** existing Azure resources to raw IaC via ARM control-plane export APIs
(`Microsoft.AzureTerraform/exportTerraform` for TF; `exportTemplate`+decompile for Bicep),
then runs a **gated cleanup** pipeline, then **symmetric fidelity validation**
(`terraform plan` for TF; ARM what-if for Bicep).

## Scope (parity with PR #2 test)
- Same 4-resource brownfield fixture: VNet+subnet, Storage+container, Key Vault+policy+secret, Log Analytics.
- Fresh isolated RG `rg-iacexport-stema-20260722` (eastus2), fresh name suffix (avoid reuse races).
- **Terraform lane = primary** (directly comparable to PR #2: `terraform plan` fidelity gate).
- **Bicep lane = secondary** (PR #1's unique capability: exportTemplate->decompile->build/lint->what-if).
- Faithful export, teardown after (confirm with user).

## Gates that matter
- TF fidelity: refined HCL + import blocks -> `terraform plan` = 0 destroy, 0 replace, imports matched, ~empty.
- Bicep fidelity: decompiled+cleaned Bicep -> `az deployment group what-if` = "no changes".
- Cleanup pipeline evidence-gates: every `.cleanup/*.json` artifact `status:"complete"` before validate runs.

## Environment (confirmed)
- BAMI tenant `4f00b3b6-2940-4f2c-b037-94637c180d30`, sub "Terraform" `e4b62b3b-...`.
- `Microsoft.AzureTerraform` RP = **Registered** (export path viable). bicep CLI present.
- CRITICAL: strip `ARM_*` env vars in-process before every `terraform` call. `az` ignores them.
- GUARDRAIL: no `terraform apply`, no `az deployment group create`. Export/plan/what-if only.

## Workdir
`...\files\live-test-pr1\`
- `fixture\` — brownfield estate (deploy, then teardown target)
- `export-tf\` — Terraform lane output + cleanup + validate
- `export-bicep\` — Bicep lane output + cleanup + validate

## Phases
1. Redeploy fixture (fresh RG/suffix).
2. TF lane: export (exportTerraform LRO via az rest) -> hygiene -> terraform-cleanup passes -> cleanup-validate.
3. Bicep lane: exportTemplate -> decompile -> bicep-cleanup -> bicep-validate (what-if).
4. Report (compare to PR #2 findings) + teardown.
