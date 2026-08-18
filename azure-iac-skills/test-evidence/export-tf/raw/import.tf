import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-iacexport-demo-20260722"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-iacexport-demo-20260722/providers/Microsoft.KeyVault/vaults/kv-iacx-p1x7q"
  to = azurerm_key_vault.res-1
}
import {
  id = "https://kv-iacx-p1x7q.vault.azure.net/secrets/demo-secret/610a627e918f46b7ab3830e9e604d8c4"
  to = azurerm_key_vault_secret.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-iacexport-demo-20260722/providers/Microsoft.Network/virtualNetworks/vnet-iacx-p1x7q"
  to = azurerm_virtual_network.res-3
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-iacexport-demo-20260722/providers/Microsoft.Network/virtualNetworks/vnet-iacx-p1x7q/subnets/snet-app"
  to = azurerm_subnet.res-4
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-iacexport-demo-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q"
  to = azurerm_log_analytics_workspace.res-5
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-iacexport-demo-20260722/providers/Microsoft.Storage/storageAccounts/stiacxp1x7q"
  to = azurerm_storage_account.res-721
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-iacexport-demo-20260722/providers/Microsoft.Storage/storageAccounts/stiacxp1x7q/blobServices/default/containers/data"
  to = azurerm_storage_container.res-723
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-iacexport-demo-20260722/providers/Microsoft.Storage/storageAccounts/stiacxp1x7q"
  to = azurerm_storage_account_queue_properties.res-725
}

