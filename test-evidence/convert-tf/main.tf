resource "azurerm_resource_group" "rg" {
  name     = "rg-iacvanilla-stema-v9r4t"
  location = "eastus2"
  tags = {
    environment = "iacvanillatest"
    owner       = "stema"
    purpose     = "iac-vanilla-livetest"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-iacv-v9r4t"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "eastus2"
  address_space       = ["10.43.0.0/16"]
  tags = {
    environment = "iacvanillatest"
    owner       = "stema"
    purpose     = "iac-vanilla-livetest"
  }
}

resource "azurerm_subnet" "app" {
  name                 = "snet-app"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.43.1.0/24"]
}

resource "azurerm_storage_account" "sa" {
  name                            = "stiacvv9r4t"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = "eastus2"
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  account_kind                    = "StorageV2"
  access_tier                     = "Hot"
  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false
  tags = {
    environment = "iacvanillatest"
    owner       = "stema"
    purpose     = "iac-vanilla-livetest"
  }
}

resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = "private"
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-iacv-v9r4t"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "eastus2"
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags = {
    environment = "iacvanillatest"
    owner       = "stema"
    purpose     = "iac-vanilla-livetest"
  }
}

resource "azurerm_key_vault" "kv" {
  name                       = "kv-iacv-v9r4t"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = "eastus2"
  tenant_id                  = "4f00b3b6-2940-4f2c-b037-94637c180d30"
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  rbac_authorization_enabled = false

  access_policy {
    tenant_id = "4f00b3b6-2940-4f2c-b037-94637c180d30"
    object_id = "4b645026-a054-4404-8f64-62929c02052c"
    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge", "Recover",
    ]
  }

  tags = {
    environment = "iacvanillatest"
    owner       = "stema"
    purpose     = "iac-vanilla-livetest"
  }
}

resource "azurerm_key_vault_secret" "demo" {
  name         = "demo-secret"
  value        = "S3cr3t-demo-value-DO-NOT-USE"
  key_vault_id = azurerm_key_vault.kv.id
}
