resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_key_vault" "kv" {
  name                       = "kv-iacx-p1x7q"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = var.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  rbac_authorization_enabled = false
  tags                       = var.tags

  access_policy {
    tenant_id          = var.tenant_id
    object_id          = var.kv_admin_object_id
    secret_permissions = ["Get", "List", "Set", "Delete", "Purge", "Recover"]
  }

  network_acls {
    bypass         = "AzureServices"
    default_action = "Allow"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-iacx-p1x7q"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.43.0.0/16"]
  tags                = var.tags
}

resource "azurerm_subnet" "snet_app" {
  name                 = "snet-app"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.43.1.0/24"]
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-iacx-p1x7q"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_storage_account" "sa" {
  name                            = "stiacxp1x7q"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.rg.name
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  account_kind                    = "StorageV2"
  access_tier                     = "Hot"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  tags                            = var.tags
}

resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = "private"
}
