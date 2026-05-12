resource "azurerm_storage_account" "learning_sa" {

  name                     = "devlearningsa"
  resource_group_name      = azurerm_resource_group.learning_rg.name
  location                 = azurerm_resource_group.learning_rg.location # implicit dependency
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = local.common_tags.environment
  }

}
