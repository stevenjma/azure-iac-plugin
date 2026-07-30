variable "kv_secret_demo_value" {
  type        = string
  sensitive   = true
  description = "Value of the adopted Key Vault secret 'demo-secret'. Supply via an untracked secrets.auto.tfvars file; never commit the real value."
}
