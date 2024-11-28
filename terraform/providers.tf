terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    subscription_id      = "ef66da19-bc52-4956-a471-9cde86350353"
    resource_group_name  = "terraform-state"
    storage_account_name = "tfkeytrfazure"
    container_name       = "tfstate"
    key                  = "keycloak.tfstate"
  }
}

provider "azurerm" {
  features {}
}