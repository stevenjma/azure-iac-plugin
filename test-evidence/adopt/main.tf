locals {
  subscription_id     = "e4b62b3b-7634-4972-8bbe-5d7197159f26"
  tenant_id           = "4f00b3b6-2940-4f2c-b037-94637c180d30"
  resource_group_name = "rg-avmtest-stema-20260721"
  resource_group_id   = "/subscriptions/${local.subscription_id}/resourceGroups/${local.resource_group_name}"

  tags = {
    environment = "avmtest"
    owner       = "stema"
    purpose     = "avm-adopt-livetest"
  }
}

module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.19.0"

  name             = "vnet-avmtest-9d6lh"
  location         = "eastus2"
  parent_id        = local.resource_group_id
  address_space    = ["10.42.0.0/16"]
  tags             = local.tags
  enable_telemetry = false

  subnets = {
    "snet-app" = {
      name                              = "snet-app"
      address_prefix                    = "10.42.1.0/24"
      default_outbound_access_enabled   = true
      private_endpoint_network_policies = "Disabled"
    }
  }
}

module "storage" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.7.3"

  name             = "stavmt9d6lh"
  location         = "eastus2"
  parent_id        = local.resource_group_id
  tags             = local.tags
  enable_telemetry = false

  account_sku_name              = "Standard_LRS"
  shared_access_key_enabled     = true
  public_network_access_enabled = true
  local_user_enabled            = true

  network_rules = {
    default_action = "Allow"
    bypass         = ["AzureServices"]
  }

  containers = {
    data = {
      name = "data"
    }
  }
}

module "keyvault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.10.2"

  name                = "kv-avmt-9d6lh"
  location            = "eastus2"
  resource_group_name = local.resource_group_name
  tenant_id           = local.tenant_id
  sku_name            = "standard"
  tags                = local.tags
  enable_telemetry    = false

  legacy_access_policies_enabled = true
  legacy_access_policies = {
    guest = {
      object_id          = "4b645026-a054-4404-8f64-62929c02052c"
      secret_permissions = ["Get", "List", "Set", "Delete", "Purge", "Recover"]
    }
  }

  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  network_acls               = null

  secrets = {
    demo = {
      name = "demo-secret"
    }
  }
  secrets_value = {
    demo = var.kv_secret_demo_value
  }
}

module "law" {
  source  = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version = "0.5.1"

  name                = "law-avmtest-9d6lh"
  location            = "eastus2"
  resource_group_name = local.resource_group_name
  tags                = local.tags
  enable_telemetry    = false

  log_analytics_workspace_internet_ingestion_enabled = "true"
  log_analytics_workspace_internet_query_enabled     = "true"
}
