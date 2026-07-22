terraform {
  required_providers {
    azurerm = {
      source  = "azurerm"
      version = "4.80.0"
    }
  }
}
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "res-0" {
  location   = "eastus2"
  managed_by = ""
  name       = "rg-iacexport-stema-20260722"
  tags = {
    environment = "iacexporttest"
    owner       = "stema"
    purpose     = "iac-export-livetest"
  }
}
resource "azurerm_key_vault" "res-1" {
  access_policy = [{
    application_id          = ""
    certificate_permissions = []
    key_permissions         = []
    object_id               = "4b645026-a054-4404-8f64-62929c02052c"
    secret_permissions      = ["Get", "List", "Set", "Delete", "Purge", "Recover"]
    storage_permissions     = []
    tenant_id               = "4f00b3b6-2940-4f2c-b037-94637c180d30"
  }]
  enable_rbac_authorization       = false
  enabled_for_deployment          = false
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = false
  location                        = "eastus2"
  name                            = "kv-iacx-p1x7q"
  public_network_access_enabled   = true
  purge_protection_enabled        = false
  rbac_authorization_enabled      = false
  resource_group_name             = azurerm_resource_group.res-0.name
  sku_name                        = "standard"
  soft_delete_retention_days      = 7
  tags = {
    environment = "iacexporttest"
    owner       = "stema"
    purpose     = "iac-export-livetest"
  }
  tenant_id = "4f00b3b6-2940-4f2c-b037-94637c180d30"
  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
}
resource "azurerm_virtual_network" "res-3" {
  address_space                  = ["10.43.0.0/16"]
  bgp_community                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  flow_timeout_in_minutes        = 0
  location                       = "eastus2"
  name                           = "vnet-iacx-p1x7q"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = azurerm_resource_group.res-0.name
  subnet = [{
    address_prefixes                              = ["10.43.1.0/24"]
    default_outbound_access_enabled               = true
    delegation                                    = []
    id                                            = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.Network/virtualNetworks/vnet-iacx-p1x7q/subnets/snet-app"
    name                                          = "snet-app"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = ""
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
  }]
  tags = {
    environment = "iacexporttest"
    owner       = "stema"
    purpose     = "iac-export-livetest"
  }
}
resource "azurerm_subnet" "res-4" {
  address_prefixes                              = ["10.43.1.0/24"]
  default_outbound_access_enabled               = true
  name                                          = "snet-app"
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
  resource_group_name                           = azurerm_resource_group.res-0.name
  service_endpoint_policy_ids                   = []
  service_endpoints                             = []
  sharing_scope                                 = ""
  virtual_network_name                          = "vnet-iacx-p1x7q"
  depends_on = [
    azurerm_virtual_network.res-3,
  ]
}
resource "azurerm_log_analytics_workspace" "res-5" {
  allow_resource_only_permissions         = true
  cmk_for_query_forced                    = false
  daily_quota_gb                          = -1
  data_collection_rule_id                 = ""
  immediate_data_purge_on_30_days_enabled = false
  internet_ingestion_enabled              = true
  internet_query_enabled                  = true
  local_authentication_disabled           = false
  local_authentication_enabled            = true
  location                                = "eastus2"
  name                                    = "law-iacx-p1x7q"
  resource_group_name                     = azurerm_resource_group.res-0.name
  retention_in_days                       = 30
  sku                                     = "PerGB2018"
  tags = {
    environment = "iacexporttest"
    owner       = "stema"
    purpose     = "iac-export-livetest"
  }
}
resource "azurerm_storage_account" "res-721" {
  access_tier                       = "Hot"
  account_kind                      = "StorageV2"
  account_replication_type          = "LRS"
  account_tier                      = "Standard"
  allow_nested_items_to_be_public   = false
  allowed_copy_scope                = ""
  cross_tenant_replication_enabled  = false
  default_to_oauth_authentication   = false
  dns_endpoint_type                 = "Standard"
  edge_zone                         = ""
  https_traffic_only_enabled        = true
  infrastructure_encryption_enabled = false
  is_hns_enabled                    = false
  large_file_share_enabled          = false
  local_user_enabled                = true
  location                          = "eastus2"
  min_tls_version                   = "TLS1_2"
  name                              = "stiacxp1x7q"
  nfsv3_enabled                     = false
  provisioned_billing_model_version = ""
  public_network_access_enabled     = true
  queue_encryption_key_type         = "Service"
  resource_group_name               = azurerm_resource_group.res-0.name
  sftp_enabled                      = false
  shared_access_key_enabled         = true
  table_encryption_key_type         = "Service"
  tags = {
    environment = "iacexporttest"
    owner       = "stema"
    purpose     = "iac-export-livetest"
  }
  blob_properties {
    change_feed_enabled           = false
    change_feed_retention_in_days = 0
    default_service_version       = ""
    last_access_time_enabled      = false
    versioning_enabled            = false
  }
  share_properties {
    retention_policy {
      days = 7
    }
  }
}
resource "azurerm_storage_container" "res-723" {
  container_access_type             = "private"
  default_encryption_scope          = "$account-encryption-key"
  encryption_scope_override_enabled = true
  metadata                          = {}
  name                              = "data"
  storage_account_id                = azurerm_storage_account.res-721.id
  storage_account_name              = ""
}

