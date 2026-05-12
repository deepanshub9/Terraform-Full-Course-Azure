# Create the resource group in its own file.
resource "azurerm_resource_group" "learning_rg" {
  name     = "dev-learning-rg"
  location = "France Central"
}
