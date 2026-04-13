terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-opella-tfstate-eastus"
    storage_account_name = "stopellatfstateeus"
    container_name       = "tfstate"
    key                  = "prod/terraform.tfstate"
  }
}

resource "azurerm_resource_group" "this" {
  name     = "rg-opella-prod-westus"
  location = var.location

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "opella-challenge"
    Region      = var.location
  }
}

module "vnet" {
  source = "../../modules/vnet"

  location            = var.location
  environment         = var.environment
  resource_group_name = azurerm_resource_group.this.name
}

# Random password
resource "random_password" "vm" {
  length           = 16
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>"
}

# Public IP
resource "azurerm_public_ip" "vm" {
  name                = "pip-opella-prod-westus"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Network Interface
resource "azurerm_network_interface" "vm" {
  name                = "nic-opella-prod-westus"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet.subnet_ids["app"]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm.id
  }
}

# Windows VM
resource "azurerm_windows_virtual_machine" "this" {
  name                = "vm-opella-prod-westus"
  computer_name       = "vmprodwestus"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  size                = "Standard_DC1s_v3"
  admin_username      = "azureadmin"
  admin_password      = random_password.vm.result

  network_interface_ids = [azurerm_network_interface.vm.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}

# Storage Account
resource "azurerm_storage_account" "this" {
  name                          = "stopellaprodwestus"
  resource_group_name           = azurerm_resource_group.this.name
  location                      = var.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  public_network_access_enabled = false
}

# Private Endpoint
resource "azurerm_private_endpoint" "storage" {
  name                = "pe-opella-storage-prod-westus"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = module.vnet.subnet_ids["private-endpoints"]

  private_service_connection {
    name                           = "storage-connection"
    private_connection_resource_id = azurerm_storage_account.this.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}

output "vm_username" {
  value = azurerm_windows_virtual_machine.this.admin_username
}

output "vm_password" {
  value     = random_password.vm.result
  sensitive = true
}

output "vm_public_ip" {
  value = azurerm_public_ip.vm.ip_address
}

output "storage_account_name" {
  value = azurerm_storage_account.this.name
}