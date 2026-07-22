output "vnet_resource_id" {
  description = "Resource ID of the adopted virtual network."
  value       = module.vnet.resource_id
}

output "storage_account_resource_id" {
  description = "Resource ID of the adopted storage account."
  value       = module.storage.resource_id
}

output "key_vault_resource_id" {
  description = "Resource ID of the adopted key vault."
  value       = module.keyvault.resource_id
}

output "log_analytics_workspace_resource_id" {
  description = "Resource ID of the adopted Log Analytics workspace."
  value       = module.law.resource_id
}
