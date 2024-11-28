resource "azurerm_resource_group" "keycloak_rg" {
  name     = "keycloak-resources"
  location = "West Europe"
}

# Network Configuration
resource "azurerm_virtual_network" "main" {
  name                = "keycloak-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.keycloak_rg.location
  resource_group_name = azurerm_resource_group.keycloak_rg.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.keycloak_rg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_network_security_group" "keycloak_nsg" {
  name                = "keycloak-nsg"
  location            = azurerm_resource_group.keycloak_rg.location
  resource_group_name = azurerm_resource_group.keycloak_rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# VM Configuration
resource "azurerm_public_ip" "keycloak_ip" {
  name                = "keycloak-ip"
  resource_group_name = azurerm_resource_group.keycloak_rg.name
  location            = azurerm_resource_group.keycloak_rg.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "keycloak_nic" {
  name                = "keycloak-nic"
  location            = azurerm_resource_group.keycloak_rg.location
  resource_group_name = azurerm_resource_group.keycloak_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.keycloak_ip.id
  }
}
resource "azurerm_storage_account" "storage" {
  name                     = "keycloakstorage${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.keycloak_rg.name
  location                 = azurerm_resource_group.keycloak_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_linux_virtual_machine" "keycloak_vm" {
  name                = "keycloak-vm"
  resource_group_name = azurerm_resource_group.keycloak_rg.name
  location            = azurerm_resource_group.keycloak_rg.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.keycloak_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}