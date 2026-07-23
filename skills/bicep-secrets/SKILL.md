---
name: bicep-secrets
description: >
  Use this skill only during bicep-cleanup Phase 3.4, or when the user explicitly asks to secure
  Bicep inputs. Remove literal secrets, mark secret parameters secure, and wire Key Vault references
  or deploy-time inputs without writing secret values to disk.
license: MIT
---

## Goal

Ensure no secret material is authored in cleartext in the Bicep, and that every secret input is
declared `@secure()` and sourced safely at deploy time. Bicep analog of `cleanup-secrets`.

## Preconditions

- Pass 3.3 (`bicep-organize`) reports `complete` or `skipped`.
- `parameterize.json` `secrets_deferred` lists candidates flagged in 3.1.

## What counts as a secret

Admin passwords, storage/account keys, connection strings, SAS tokens, client secrets,
certificates/private keys, API keys, and any property the schema marks sensitive/write-only
(e.g. `administratorLoginPassword`, `primaryKey`, `connectionString`).

## Procedure

1. **Locate** every secret-bearing value: the `secrets_deferred` list plus a fresh scan for the
   patterns above (including inside `modules/*.bicep`).
2. **Declare `@secure()`.** For each, ensure a parameter exists and is decorated:
   `@secure() param sqlAdminPassword string`. Propagate `@secure()` through every module boundary
   the value crosses.
3. **Strip literals.** Remove any literal secret value from the template. Never write the real
   value to disk. If the decompiled export contained a literal secret, replace it with the
   `@secure()` param reference and record that a literal was present (NOT its value) in
   `literal_secrets_removed`.
4. **Prefer Key Vault references.** Where appropriate, wire an `existing` Key Vault +
   `getSecret()` reference (for module params) or document a `parameters.json` with a
   `reference: { keyVault: … , secretName: … }` binding. Produce a
   `<workdir>/secrets.parameters.example.json` template with placeholders — never real values.
5. **Emit a warning** to the user: which parameters need values, and that they must be supplied
   via Key Vault reference or a secured deploy-time parameter (never committed).

## Guardrails

- NEVER write a real secret value to any file. Placeholders only.
- NEVER echo a discovered secret value back to the user — reference it by parameter name.
- A `@secure()` parameter must never be used in an `output` or string-interpolated into a
  non-secure sink.

## Acceptance Criteria

Write `<workdir>/.cleanup/secrets.json`:

```json
{
  "pass": "3.4-secrets",
  "status": "complete",
  "secrets_identified": ["sqlAdminPassword", "storageAccountKey"],
  "secure_params_declared": 2,
  "literal_secrets_removed": 1,
  "keyvault_wired": ["sqlAdminPassword"],
  "example_params_file": "secrets.parameters.example.json"
}
```

Not complete unless every identified secret is a declared `@secure()` parameter, no literal secret
remains in any file, an example params file exists when `secrets_identified` is non-empty, and
`checklist.json` pass `3.4-secrets` is `complete`.
