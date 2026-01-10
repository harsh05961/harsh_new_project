resource "azurerm_resource_group" "myrg" {
  name     = "${var.name}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "myvnet" {
  name                = "${var.name}-vnet"
  address_space       = var.address_space
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

resource "azurerm_subnet" "mysubnet" {
  name                 = "${var.name}-subnet"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = var.address_prefixes
}
resource "azurerm_public_ip" "mypubip" {
  name                = "${var.name}-PIP"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  allocation_method   = var.allocation_method
  sku                 = var.sku
}
resource "azurerm_network_interface" "mynic" {
  name                = "${var.name}-nic"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = var.name
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = var.private_ip_address_allocation
    public_ip_address_id          = azurerm_public_ip.mypubip.id
  }
}

resource "azurerm_network_security_group" "mysecgroup" {
  name                = "${var.name}-nsg"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  security_rule {
    name                       = var.security_rule.name
    priority                   = var.security_rule.priority
    direction                  = var.security_rule.direction
    access                     = var.security_rule.access
    protocol                   = var.security_rule.protocol
    source_port_range          = var.security_rule.source_port_range
    destination_port_range     = var.security_rule.destination_port_range
    source_address_prefix      = var.security_rule.source_address_prefix
    destination_address_prefix = var.security_rule.destination_address_prefix
  }
  security_rule {
    name                       = "http"
    priority                   = "110"
    direction                  = var.security_rule.direction
    access                     = var.security_rule.access
    protocol                   = var.security_rule.protocol
    source_port_range          = var.security_rule.source_port_range
    destination_port_range     = "80"
    source_address_prefix      = var.security_rule.source_address_prefix
    destination_address_prefix = var.security_rule.destination_address_prefix
  }
}

resource "azurerm_subnet_network_security_group_association" "mysecgroupasso" {
  subnet_id                 = azurerm_subnet.mysubnet.id
  network_security_group_id = azurerm_network_security_group.mysecgroup.id
}

resource "azurerm_linux_virtual_machine" "myubuntuvm" {
  name                = "myubuntumachine"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.mynic.id,
  ]
  disable_password_authentication = var.disable_password_authentication

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apache2",
      "sudo systemctl start apache2"
    ]

    connection {
      type     = "ssh"
      user     = var.admin_username
      password = var.admin_password
      host     = self.public_ip_address
    }
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
