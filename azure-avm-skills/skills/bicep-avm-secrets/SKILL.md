---
name: bicep-avm-secrets
description: >
  bicep-avm-compose Phase 3.4 — identify secret-bearing AVM module inputs and wire them safely:
  mark them @secure(), remove any literal secret values harvested by the oracle, and replace with
  Key Vault references or deploy-time parameters. Never emits a real secret to disk. Writes secrets.json.
license: MIT
---

## Goal

Ensure no secret material is authored in cleartext in the composed Bicep, and that every secret
input crossing into an AVM module is declared `@secure()` and sourced safely at deploy time. This
matters more in the AVM lane than the raw lane because the **config oracle harvests live values** —
including secret-shaped ones — and those must never be pinned into `params`.

## Preconditions

- Pass 3.3 (`bicep-avm-organize`) reports `complete` or `skipped`.
- `inputs.json` `secrets_deferred` (per module) lists candidates flagged in 3.2.

## What counts as a secret

Admin passwords, storage/account keys, connection strings, SAS tokens, client secrets,
certificates/private keys, API keys, and any module input the schema marks `@secure()` or
sensitive/write-only (e.g. `administratorLoginPassword`, module `secrets[].value`, `primaryKey`).

## Procedure

1. **Locate** every secret-bearing input: the per-module `secrets_deferred` lists plus a fresh scan
   of the composed files (including `modules/*.bicep` wrappers) for the patterns above and for any
   value that came from a `listKeys`/`listConnectionStrings` oracle harvest.
2. **Declare `@secure()` params.** For each, ensure a top-level parameter exists and is decorated:
   `@secure() param sqlAdminPassword string`. Propagate `@secure()` through every module input the
   value feeds — AVM secure inputs must receive a secure param, never a literal.
3. **Strip literals from the oracle projection.** If 3.2 pinned a harvested secret value into a
   module param, replace it with the `@secure()` param reference and record that a literal was
   present (NOT its value) in `literal_secrets_removed`. This is the primary AVM-lane risk.
4. **Prefer Key Vault references.** Wire an `existing` Key Vault + `getSecret()` for module params,
   or (for `avm/res/key-vault/vault`'s own `secrets` input) use a `reference` binding. Produce
   `<workdir>/secrets.parameters.example.json` with placeholders — never real values.
5. **Emit a warning** to the user: which parameters need values and that they must be supplied via
   Key Vault reference or a secured deploy-time parameter (never committed).

## Guardrails

- NEVER write a real secret value to any file. Placeholders only. The oracle may contain live
  secret values — treat `.avm/harvest/*.json` as sensitive and never copy secret fields into code.
- NEVER echo a discovered secret value back to the user — reference it by parameter name.
- A `@secure()` parameter must never be used in an `output` or string-interpolated into a
  non-secure sink.
- A secure AVM module input must be fed only by an `@secure()` param or a Key Vault reference.

## Acceptance Criteria

Write `<workdir>/.avm/secrets.json`:

```json
{
  "pass": "3.4-secrets",
  "status": "complete",
  "secrets_identified": ["sqlAdminPassword", "storagePrimaryKey"],
  "secure_params_declared": 2,
  "literal_secrets_removed": 1,
  "keyvault_wired": ["sqlAdminPassword"],
  "example_params_file": "secrets.parameters.example.json"
}
```

Not complete unless every identified secret is a declared `@secure()` parameter, no literal secret
remains in any file (including harvested values from 3.2), each secure module input is fed by a
secure param or Key Vault reference, an example params file exists when `secrets_identified` is
non-empty, and `checklist.json` pass `3.4-secrets` is `complete`.

## Non-goals

- Wiring non-secret inputs (3.2). Organizing (3.3). What-if (4).
