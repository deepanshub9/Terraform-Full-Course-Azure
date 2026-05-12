resource "azurerm_resource_group" "rg_primary" {
  name     = "dev-primary-rg"
  location = "France Central"

  tags = {
    department = "IT"
    project    = "Learning"
  }
}

resource "azurerm_resource_group" "rg_secondary" {
  name     = "dev-secondary-rg"
  location = "France Central"

  tags = {
    department = "IT"
    project    = "Learning"
  }
}
