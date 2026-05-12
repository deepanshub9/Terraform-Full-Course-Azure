variable "prefix" {
  default = "day17"
  type    = string
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = "France Central"
}

// Create the App Service plan for the web app.
resource "azurerm_app_service_plan" "asp" {
  name                = "${var.prefix}-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku {
    tier = "Standard"
    size = "S1"
  }
}

// Create the main web app.
resource "azurerm_app_service" "as" {
  name                = "${var.prefix}-webapp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp.id
}

// Create a staging slot for the web app.
resource "azurerm_app_service_slot" "slot" {
  name                = "${var.prefix}-staging"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp.id
  app_service_name    = azurerm_app_service.as.name
}

// Connect the main app to source control.
resource "azurerm_app_service_source_control" "scm" {
  app_id   = azurerm_app_service.as.id
  repo_url = "https://github.com/piyushsachdeva/tf-sample-bg"
  branch   = "master"
}

// Connect the staging slot to source control.
resource "azurerm_app_service_source_control_slot" "scm1" {
  slot_id  = azurerm_app_service_slot.slot.id
  repo_url = "https://github.com/piyushsachdeva/tf-sample-bg"
  branch   = "appServiceSlot_Working_DO_NOT_MERGE"
}

// Make the staging slot active.
resource "azurerm_web_app_active_slot" "active" {
  slot_id = azurerm_app_service_slot.slot.id

}
