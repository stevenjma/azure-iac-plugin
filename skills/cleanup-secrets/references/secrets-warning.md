# Terraform cleanup mandatory secrets warning template

After `cleanup-secrets` runs, surface this table verbatim to the user before any
`terraform plan` runs. Replace placeholders with detected values.

```
⚠️  SECRETS REQUIRED — Code will fail without these values:

┌──────────────────────────┬────────────────────────┬───────────┐
│  Variable                │ Needed By              │ Condition │
├──────────────────────────┼────────────────────────┼───────────┤
│  storage_account_key     │ <N resources>          │ Always*   │
│  sql_admin_password      │ <N resources>          │ Always    │
│  client_secret           │ <N resources>          │ If SPN    │
└──────────────────────────┴────────────────────────┴───────────┘

Action needed:
1. Copy secrets.auto.tfvars.example → secrets.auto.tfvars
2. Fill in real values (get from Azure Portal or Key Vault)
3. Add *.auto.tfvars to .gitignore
```

The orchestrator's summary must NOT claim "complete" unless this table was shown.
