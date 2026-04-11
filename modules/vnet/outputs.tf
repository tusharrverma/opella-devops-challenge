output "vnet_id" {
  description = "The ID of the VNet"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "The name of the VNet"
  value       = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "Map of subnet IDs (key = subnet name)"
  value       = { for k, v in azurerm_subnet.this : k => v.id }
}

output "nsg_id" {
  description = "NSG ID (if created)"
  value       = var.create_nsg ? azurerm_network_security_group.this[0].id : null
}