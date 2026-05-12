variable "DAY" {
  type    = string
  default = "day24"

}

variable "location" {
  type    = string
  default = "France Central"
}

# Create the resource group for the web app demo.
resource "azurerm_resource_group" "rg1" {
  name     = "${var.DAY}-rg"
  location = var.location
}

# Create the virtual network for the web app.
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.DAY}-vnet"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = ["10.0.0.0/16"]


}

# Create the subnet used by the web app resources.
resource "azurerm_subnet" "sn" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create the app service plan for the Linux web app.
resource "azurerm_service_plan" "name" {
  name                = "${var.DAY}-plan"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  os_type             = "Linux"
  sku_name            = "B1"


}

# Create the Linux web app that runs the sample app.
resource "azurerm_linux_web_app" "name" {
  name                = "${var.DAY}-webapp-18462"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  service_plan_id     = azurerm_service_plan.name.id

  site_config {
    application_stack {
      node_version = "18-lts"
    }
  }


}
