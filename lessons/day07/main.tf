resource "azurerm_resource_group" "learning_rg" {
  name     = "${var.environment}-learning-rg"
  location = var.allowed_locations[0]
}

resource "azurerm_virtual_network" "learning_vnet" {
  name                = "${var.environment}-learning-vnet"
  address_space       = [element(var.network_config, 0)]
  location            = azurerm_resource_group.learning_rg.location
  resource_group_name = azurerm_resource_group.learning_rg.name
}

resource "azurerm_subnet" "learning_subnet" {
  name                 = "${var.environment}-learning-subnet"
  resource_group_name  = azurerm_resource_group.learning_rg.name
  virtual_network_name = azurerm_virtual_network.learning_vnet.name
  address_prefixes     = ["${element(var.network_config, 1)}/${element(var.network_config, 2)}"]
}

resource "azurerm_network_interface" "learning_nic" {
  name                = "${var.environment}-learning-nic"
  location            = azurerm_resource_group.learning_rg.location
  resource_group_name = azurerm_resource_group.learning_rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.learning_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "learning_vm" {
  name                  = "${var.environment}-learning-vm"
  location              = azurerm_resource_group.learning_rg.location
  resource_group_name   = azurerm_resource_group.learning_rg.name
  network_interface_ids = [azurerm_network_interface.learning_nic.id]
  vm_size               = var.allowed_vm_sizes[0]

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = var.is_delete

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = var.vm_config.sku
    version   = var.vm_config.version
  }
  storage_os_disk {
    name              = "${var.environment}-learning-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = var.storage_disk
  }
  os_profile {
    computer_name  = "${var.environment}vm"
    admin_username = "azureuser"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = var.resource_tags["environment"]
    managed_by  = var.resource_tags["managed_by"]
    department  = var.resource_tags["department"]
  }
}
