terraform {
  required_version = ">= 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  subscription_id                 = local.subscription_id
  tenant_id                       = local.tenant_id
  resource_provider_registrations = "none"
  features {}
}

provider "azapi" {
  subscription_id = local.subscription_id
  tenant_id       = local.tenant_id
}
