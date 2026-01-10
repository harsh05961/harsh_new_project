name = "bbq"

address_prefixes = ["10.0.2.0/24"]

allocation_method = "Static"

location = "West Europe"

sku = "Standard"

private_ip_address_allocation = "Dynamic"

security_rule = {

  name                       = "mytestsecrule"
  priority                   = "100"
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefix      = "*"
  destination_address_prefix = "*"

}

address_space = ["10.0.0.0/16"]

size = "Standard_F2"

admin_username = "cloudadmin"

admin_password = "Abcd@12345678"

disable_password_authentication = "false"
