output "vnet_id" {
  description = "The ID of the created Virtual Network"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "The name of the created Virtual Network"
  value       = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "Map of all subnet IDs (key = subnet name, e.g. app, private-endpoints)"
  value       = { for k, v in azurerm_subnet.this : k => v.id }
}

output "nsg_id" {
  description = "ID of the Network Security Group (null if create_nsg = false)"
  value       = var.create_nsg ? azurerm_network_security_group.this[0].id : null
}