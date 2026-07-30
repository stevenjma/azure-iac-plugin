import {
  id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
  to = azurerm_resource_group.rg
}

import {
  id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.KeyVault/vaults/kv-iacx-p1x7q"
  to = azurerm_key_vault.kv
}

import {
  id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualNetworks/vnet-iacx-p1x7q"
  to = azurerm_virtual_network.vnet
}

import {
  id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualNetworks/vnet-iacx-p1x7q/subnets/snet-app"
  to = azurerm_subnet.snet_app
}

import {
  id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q"
  to = azurerm_log_analytics_workspace.law
}

import {
  id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Storage/storageAccounts/stiacxp1x7q"
  to = azurerm_storage_account.sa
}

import {
  id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Storage/storageAccounts/stiacxp1x7q/blobServices/default/containers/data"
  to = azurerm_storage_container.data
}
