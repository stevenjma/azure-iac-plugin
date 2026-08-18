# PR#2 (AVM adopt) — live test-evidence index

Two lanes were run against the SAME shared brownfield fixture (8 resources,
suffix `s4r1k`, RG `rg-iacshared-demo-s4r1k`, eastus2 — since destroyed).
Both are real live-Azure runs; nothing hand-authored.

## Terraform lane — `adopt/`
Full TEST adopt output (`.avm/` harvest+reconciliation, imports.tf, main.tf,
plan.out.txt/plan2.out.txt). See `REPORT.md` + `LEARNINGS.md`.
Final: 6 import / 1 add / 4 change → **zero real drift** after oracle feed.

## Bicep lane — `adopt-bicep/`  (both-lane requirement)
`main.bicep` (AVM public-registry modules) + `whatif-final.json` (raw ARM what-if).
Final: **2 NoChange + 5 cosmetic Modify → zero genuine behavioral drift**, after
oracle feed + 4 secure-default overrides (forceCmkForQuery, requireInfrastructureEncryption,
blob+container soft-delete). See `adopt-bicep/FINDINGS.txt`.

## Cross-lane headline (the INVERSE asymmetry)
A brownfield AVM adopt cannot reach *true* zero-diff on either lane:
- **TF (azapi):** always ≥1 phantom "to add" (`time_sleep`) + null/api-version churn.
- **Bicep (AVM):** every AVM-authored resource stays `Modify` (AVM writes explicit
  property values the ARM RP omits on GET); only pure-ARM vnet/subnet reach NoChange.

The reusable secure-default drift table + residual thesis is captured in
`skills/brownfield-avm-adopt/reference/reconciliation-catalog.md`.
