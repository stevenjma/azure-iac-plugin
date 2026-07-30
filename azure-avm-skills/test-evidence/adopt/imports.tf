# Config-driven import blocks for the adopted brownfield estate.
# azapi resources (vnet, subnet, storage account, container) import by ARM id;
# azurerm resources (key vault, access policy, secret, LAW) import by their
# respective id shapes. Secret uses the versioned data-plane id.

import {
  to = module.vnet.azapi_resource.vnet
  id = "${local.resource_group_id}/providers/Microsoft.Network/virtualNetworks/vnet-avmtest-9d6lh"
}

import {
  to = module.vnet.module.subnet["snet-app"].azapi_resource.subnet[0]
  id = "${local.resource_group_id}/providers/Microsoft.Network/virtualNetworks/vnet-avmtest-9d6lh/subnets/snet-app"
}

import {
  to = module.storage.azapi_resource.this
  id = "${local.resource_group_id}/providers/Microsoft.Storage/storageAccounts/stavmt9d6lh"
}

import {
  to = module.storage.module.containers["data"].azapi_resource.this
  id = "${local.resource_group_id}/providers/Microsoft.Storage/storageAccounts/stavmt9d6lh/blobServices/default/containers/data"
}

import {
  to = module.keyvault.azurerm_key_vault.this
  id = "${local.resource_group_id}/providers/Microsoft.KeyVault/vaults/kv-avmt-9d6lh"
}

import {
  to = module.keyvault.azurerm_key_vault_access_policy.this["guest"]
  id = "${local.resource_group_id}/providers/Microsoft.KeyVault/vaults/kv-avmt-9d6lh/objectId/4b645026-a054-4404-8f64-62929c02052c"
}

import {
  to = module.keyvault.module.secrets["demo"].azurerm_key_vault_secret.this
  id = "https://kv-avmt-9d6lh.vault.azure.net/secrets/demo-secret/b334bb82dfa04a61bb17ddd17d6accf3"
}

import {
  to = module.law.azurerm_log_analytics_workspace.this
  id = "${local.resource_group_id}/providers/Microsoft.OperationalInsights/workspaces/law-avmtest-9d6lh"
}
