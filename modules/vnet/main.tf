terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

locals {
  vnet_name     = "vnet-opella-${var.environment}-${replace(var.location, " ", "")}"
  nsg_name      = "nsg-opella-${var.environment}-${replace(var.location, " ", "")}"
  subnet_prefix = "snet-opella-${var.environment}-${replace(var.location, " ", "")}"
}

resource "azurerm_virtual_network" "this" {
  name                = local.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
}

resource "azurerm_subnet" "this" {
  for_each = var.subnets

  name                 = "${local.subnet_prefix}-${each.key}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value.address_prefixes

  private_endpoint_network_policies = each.value.private_endpoint_network_policies
}

resource "azurerm_network_security_group" "this" {
  count = var.create_nsg ? 1 : 0

  name                = local.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "rdp" {
  count = var.create_nsg ? 1 : 0

  name                        = "Allow-RDP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*" # Demo only - In real prod use your IP or Azure Bastion
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this[0].name
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = var.create_nsg ? var.subnets : {}

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.this[0].id
}