# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "2021-LEARN-eastus-rg"
  location = "East US"
  tags = {
    iac       = "terraform"
    createdby = "ashikkhulal"
    project   = "LEARN"
  }
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "2021-LEARN-eastus-vnet"
  address_space       = ["10.0.0.0/24"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    iac       = "terraform"
    createdby = "ashikkhulal"
    project   = "LEARN"
  }
}

# Create a subnet
resource "azurerm_subnet" "subnet" {
  name                 = "2021-LEARN-eastus-snet-01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Create a Public IPs
resource "azurerm_public_ip" "public_ip" {
  name                = "2021-LEARN-jenkins-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"

  tags = {
    iac       = "terraform"
    createdby = "ashikkhulal"
    project   = "LEARN"
  }
}

# Create a NSG and rules
resource "azurerm_network_security_group" "nsg" {
  name                = "2021-LEARN-jenkins-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "PORT_8080"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    iac       = "terraform"
    createdby = "ashikkhulal"
    project   = "LEARN"
  }
}

# Create a network interface
resource "azurerm_network_interface" "nic" {
  name                = "2021-LEARN-jenkins-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "jenkinsNICConfiguration"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Connect network interface and security group
resource "azurerm_network_interface_security_group_association" "nic-nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create a linux virtual machine

resource "azurerm_linux_virtual_machine" "linuxvm" {
  name                            = "jenkins"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  network_interface_ids           = [azurerm_network_interface.nic.id]
  size                            = "Standard_B2s"
  computer_name                   = "jenkins-ubuntu-vm"
  admin_username                  = "azureuser"
  admin_password                  = "Password@123"
  disable_password_authentication = false

  source_image_reference {               #for redhat 7 version, use following
    publisher = "Canonical"              #Publisher="RedHat"
    offer     = "UbuntuServer"           #offer="RHEL"
    sku       = "18.04-LTS"              #sku="7-LVM"
    version   = "latest"                 # remove version
  }

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  custom_data = filebase64("${path.module}/jenkins_setup_ubuntu.sh")                # here include bash script file for rhel

  tags = {
    iac       = "terraform"
    createdby = "ashikkhulal"
    project   = "LEARN"
  }
}