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
  subscription_id = var.subscription_id

  features {

  }

}

variable "subscription_id" {
  description = "Azure subscription ID used by the AzureRM provider."
  type        = string
  sensitive   = true
}

# Create the resource group for the first Azure example.
resource "azurerm_resource_group" "learning_rg" {
  name     = "dev-learning-rg"
  location = "France Central"
}

# Create the storage account that goes with the resource group.
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
