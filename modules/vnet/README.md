<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.rdp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | VNet address space | `list(string)` | <pre>[<br/>  "10.0.0.0/16"<br/>]</pre> | no |
| <a name="input_create_nsg"></a> [create\_nsg](#input\_create\_nsg) | Whether to create and associate NSG | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (dev/prod) | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource Group name | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Map of subnets (name => config) | <pre>map(object({<br/>    address_prefixes                  = list(string)<br/>    private_endpoint_network_policies = string<br/>  }))</pre> | <pre>{<br/>  "app": {<br/>    "address_prefixes": [<br/>      "10.0.1.0/24"<br/>    ],<br/>    "private_endpoint_network_policies": "Disabled"<br/>  },<br/>  "private-endpoints": {<br/>    "address_prefixes": [<br/>      "10.0.2.0/24"<br/>    ],<br/>    "private_endpoint_network_policies": "NetworkSecurityGroupEnabled"<br/>  }<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nsg_id"></a> [nsg\_id](#output\_nsg\_id) | ID of the Network Security Group (null if create\_nsg = false) |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | Map of all subnet IDs (key = subnet name, e.g. app, private-endpoints) |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | The ID of the created Virtual Network |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | The name of the created Virtual Network |
<!-- END_TF_DOCS -->