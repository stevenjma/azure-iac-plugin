terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  subscription_id                 = "00000000-0000-0000-0000-000000000000"
  tenant_id                       = "11111111-1111-1111-1111-111111111111"
  resource_provider_registrations = "none"
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

locals {
  location = "eastus2"
  tenant_id = "11111111-1111-1111-1111-111111111111"
  # disposable test object id (signed-in guest) — data-plane access for secret creation
  admin_object_id = "00000000-0000-0000-0000-000000000104"
  tags = {
    environment = "avmtest"
    owner       = "demo"
    purpose     = "avm-adopt-livetest"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-avmtest-demo-20260721"
  location = local.location
  tags     = local.tags
}

# ---------- Networking ----------
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-avmtest-9d6lh"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.42.0.0/16"]
  tags                = local.tags
}

resource "azurerm_subnet" "app" {
  name                 = "snet-app"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.42.1.0/24"]
}

# ---------- Storage ----------
resource "azurerm_storage_account" "sa" {
  name                     = "stavmt9d6lh"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  allow_nested_items_to_be_public = false
  tags                            = local.tags
}

resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = "private"
}

# ---------- Log Analytics ----------
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-avmtest-9d6lh"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags
}

# ---------- Key Vault (+ secret) ----------
resource "azurerm_key_vault" "kv" {
  name                       = "kv-avmt-9d6lh"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  tenant_id                  = local.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  rbac_authorization_enabled = false

  access_policy {
    tenant_id = local.tenant_id
    object_id = local.admin_object_id
    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge", "Recover",
    ]
  }

  tags = local.tags
}

resource "azurerm_key_vault_secret" "demo" {
  name         = "demo-secret"
  value        = "S3cr3t-demo-value-DO-NOT-USE"
  key_vault_id = azurerm_key_vault.kv.id
}
