variable "subscription_id" {
  description = "Azure subscription ID targeted by the azurerm provider."
  type        = string
}

variable "location" {
  description = "Azure region for all resources in this resource group."
  type        = string
  default     = "eastus2"
}

variable "resource_group_name" {
  description = "Name of the resource group that contains the estate."
  type        = string
  default     = "rg-iacexport-demo-20260722"
}

variable "tags" {
  description = "Common tags applied to every resource."
  type        = map(string)
  default = {
    environment = "iacexporttest"
    owner       = "demo"
    purpose     = "iac-export-livetest"
  }
}

variable "tenant_id" {
  description = "Entra ID tenant used by the Key Vault and its access policy."
  type        = string
  default     = "11111111-1111-1111-1111-111111111111"
}

variable "kv_admin_object_id" {
  description = "Object ID granted secret permissions on the Key Vault access policy."
  type        = string
  default     = "00000000-0000-0000-0000-000000000104"
}
