variable "location" {
  description = "Azure region"
  type        = string
}

variable "address_space" {
  description = "VNet address space"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "Map of subnets (name => config)"
  type = map(object({
    address_prefixes                  = list(string)
    private_endpoint_network_policies = string
  }))
  default = {
    app = {
      address_prefixes                  = ["10.0.1.0/24"]
      private_endpoint_network_policies = "Disabled"
    }
    private-endpoints = {
      address_prefixes                  = ["10.0.2.0/24"]
      private_endpoint_network_policies = "NetworkSecurityGroupEnabled"
    }
  }
}

variable "create_nsg" {
  description = "Whether to create and associate NSG"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Environment name (dev/prod)"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}