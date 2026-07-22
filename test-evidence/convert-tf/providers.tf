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
  subscription_id = "e4b62b3b-7634-4972-8bbe-5d7197159f26"
  tenant_id       = "4f00b3b6-2940-4f2c-b037-94637c180d30"
  features {}
}
