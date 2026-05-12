terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.27.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "azurerm" {
  features {

  }

}

resource "azurerm_resource_group" "learning_rg" {
  name     = "dev-learning-rg"
  location = "France Central"
}

resource "azurerm_storage_account" "learning_sa" {

  name                     = "devlearningsa"
  resource_group_name      = azurerm_resource_group.learning_rg.name
  location                 = azurerm_resource_group.learning_rg.location # implicit dependency
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
    purpose     = "learning"
  }
}
