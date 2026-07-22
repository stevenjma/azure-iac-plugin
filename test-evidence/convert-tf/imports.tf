import {
  to = azurerm_resource_group.rg
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacvanilla-stema-v9r4t"
}

import {
  to = azurerm_virtual_network.vnet
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacvanilla-stema-v9r4t/providers/Microsoft.Network/virtualNetworks/vnet-iacv-v9r4t"
}

import {
  to = azurerm_subnet.app
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacvanilla-stema-v9r4t/providers/Microsoft.Network/virtualNetworks/vnet-iacv-v9r4t/subnets/snet-app"
}

import {
  to = azurerm_storage_account.sa
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacvanilla-stema-v9r4t/providers/Microsoft.Storage/storageAccounts/stiacvv9r4t"
}

import {
  to = azurerm_storage_container.data
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacvanilla-stema-v9r4t/providers/Microsoft.Storage/storageAccounts/stiacvv9r4t/blobServices/default/containers/data"
}

import {
  to = azurerm_log_analytics_workspace.law
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacvanilla-stema-v9r4t/providers/Microsoft.OperationalInsights/workspaces/law-iacv-v9r4t"
}

import {
  to = azurerm_key_vault.kv
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacvanilla-stema-v9r4t/providers/Microsoft.KeyVault/vaults/kv-iacv-v9r4t"
}

import {
  to = azurerm_key_vault_secret.demo
  id = "https://kv-iacv-v9r4t.vault.azure.net/secrets/demo-secret/6294afd85515494f80e7df60180e18d4"
}
