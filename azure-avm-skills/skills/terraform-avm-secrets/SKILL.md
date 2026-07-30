---
name: terraform-avm-secrets
description: >
  terraform-avm-compose Phase 3.4 — identify secret-bearing AVM module inputs and wire them safely:
  declare them `sensitive` (or ephemeral/write-only), remove any literal secret values harvested by
  the oracle, and replace with Key Vault data/ephemeral sources or deploy-time variables. Never emits
  a real secret to disk or state. Writes secrets.json.
license: MIT
---

## Goal

Ensure no secret material is authored in cleartext in the composed Terraform, and that every secret
input crossing into an AVM module is declared `sensitive = true` (and, where possible, kept out of
state via an ephemeral/write-only value) and sourced safely at apply time. This matters more in the
AVM lane than the raw lane because the **config oracle harvests live values** — including secret-
shaped ones — and those must never be pinned into a module block or a committed `.tfvars`.

## Preconditions

- Pass 3.3 (`terraform-avm-organize`) reports `complete` or `skipped`.
- `inputs.json` `secrets_deferred` (per module) lists candidates flagged in 3.2.

## What counts as a secret

Admin passwords, storage/account keys, connection strings, SAS tokens, client secrets,
certificates/private keys, API keys, and any module input the schema marks sensitive or write-only
(e.g. `administrator_login_password`, module `secrets[].value`, `primary_access_key`).

## Procedure

1. **Locate** every secret-bearing input: the per-module `secrets_deferred` lists plus a fresh scan
   of the composed files (`main.tf`/`*.tf`, `variables.tf`) for the patterns above and for any value
   that came from a `listKeys`/`listConnectionStrings` oracle harvest.
2. **Declare `sensitive` variables.** For each, ensure a top-level `variable` exists with
   `sensitive = true` and no committed `default`. Prefer keeping the value out of state entirely:
   an **ephemeral** variable (`ephemeral = true`, Terraform ≥1.10) or a **write-only** module
   argument (≥1.11) where the module supports one. Propagate sensitivity through every module input
   the value feeds — AVM sensitive inputs must receive a sensitive variable, never a literal.
3. **Strip literals from the oracle projection.** If 3.2 pinned a harvested secret value into a
   module argument, replace it with the sensitive variable reference and record that a literal was
   present (NOT its value) in `literal_secrets_removed`. This is the primary AVM-lane risk.
4. **Prefer Key Vault references.** Wire `data "azurerm_key_vault_secret"` — or, to keep the value
   out of state, `ephemeral "azurerm_key_vault_secret"` (Terraform ≥1.10) — for module inputs, or
   (for `Azure/avm-res-keyvault-vault/azurerm`'s own `secrets` input) source values from that data/
   ephemeral block. Produce `<workdir>/secrets.auto.tfvars.example` with placeholders — never real
   values.
5. **Emit a warning** to the user: which variables need values, that they must be supplied via a Key
   Vault reference, a secured `*.tfvars`, or a CI/CD secret (never committed), and that the real
   `secrets.auto.tfvars` belongs in `.gitignore`.

## Guardrails

- NEVER write a real secret value to any file. Placeholders only. The oracle may contain live secret
  values — treat `.avm/harvest/*.json` as sensitive and never copy secret fields into code or tfvars.
- NEVER echo a discovered secret value back to the user — reference it by variable name.
- A `sensitive` variable must never feed a non-sensitive `output` or be interpolated into a
  non-sensitive sink.
- A sensitive AVM module input must be fed only by a sensitive variable or a Key Vault data/ephemeral
  source.
- `sensitive = true` masks CLI output but **still persists in state** — prefer ephemeral/write-only
  for true secrets, and treat the state file itself as sensitive (remote backend, encrypted).

## Acceptance Criteria

Write `<workdir>/.avm/secrets.json`:

```json
{
  "pass": "3.4-secrets",
  "status": "complete",
  "secrets_identified": ["sql_administrator_login_password", "storage_primary_access_key"],
  "sensitive_vars_declared": 2,
  "literal_secrets_removed": 1,
  "keyvault_wired": ["sql_administrator_login_password"],
  "example_tfvars_file": "secrets.auto.tfvars.example"
}
```

Not complete unless every identified secret is a declared `sensitive` (or ephemeral/write-only)
variable, no literal secret remains in any file or committed `.tfvars` (including harvested values
from 3.2), each sensitive module input is fed by a sensitive variable or Key Vault reference, an
example tfvars file exists when `secrets_identified` is non-empty, and `checklist.json` pass
`3.4-secrets` is `complete`.

## Non-goals

- Wiring non-secret inputs (3.2). Organizing (3.3). Plan (4).
