// Create the resource group with lifecycle rules and validation.
resource "azurerm_resource_group" "learning_rg" {


  name     = "${var.environment}-learning-rg"
  location = var.location
  tags = {
    environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
    # ignore_changes = [ tags ]
    precondition {
      condition     = contains(var.allowed_locations, var.location)
      error_message = "Please enter a valid location!"
    }

  }

}

// Create one storage account for each name in the map or list.
resource "azurerm_storage_account" "learning_sa" {

  for_each                 = var.storage_account_name
  name                     = each.value
  resource_group_name      = azurerm_resource_group.learning_rg.name
  location                 = azurerm_resource_group.learning_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [account_replication_type]
    replace_triggered_by  = [azurerm_resource_group.learning_rg.id]
  }
}
