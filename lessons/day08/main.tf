// Create the resource group for the multiple-resource example.
resource "azurerm_resource_group" "learning_rg" {
  name     = "${var.environment}-learning-rg"
  location = var.allowed_locations[0]
}

// Create one storage account entry for each name in the list.
resource "azurerm_storage_account" "learning_sa" {
  for_each                 = var.storage_account_name
  name                     = each.value
  resource_group_name      = azurerm_resource_group.learning_rg.name
  location                 = azurerm_resource_group.learning_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = var.environment
    purpose     = "learning"
  }
}
