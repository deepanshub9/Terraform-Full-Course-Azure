# Create a resource group
resource "azurerm_resource_group" "sql_rg" {
  name     = "dev-sql-rg"
  location = "France Central"
}

# Create SQL Server
resource "azurerm_mssql_server" "sql_server" {
  name                         = "dev-sql-server-${random_string.sql_suffix.result}"
  resource_group_name          = azurerm_resource_group.sql_rg.name
  location                     = azurerm_resource_group.sql_rg.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "P@ssw0rd${random_password.sql_password.result}"
}

# Generate random suffix for SQL server name uniqueness
resource "random_string" "sql_suffix" {
  length  = 8
  special = false
  upper   = false
  numeric = true
}

# Generate random password for SQL admin
resource "random_password" "sql_password" {
  length  = 12
  special = true
  upper   = true
  lower   = true
  numeric = true
}

# Create a sample SQL Database
resource "azurerm_mssql_database" "sampledb" {
  name      = "sampledb"
  server_id = azurerm_mssql_server.sql_server.id
}

# Create a Firewall rule
resource "azurerm_mssql_firewall_rule" "firewall_rule" {
  name             = "dev-sql-firewall"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"         # Replace with your public IP
  end_ip_address   = "255.255.255.255" # Replace with your public IP
}
