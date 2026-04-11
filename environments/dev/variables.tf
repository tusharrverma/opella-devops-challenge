variable "location" {
  type        = string
  default     = "eastus"
  description = "Azure region for the dev environment"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment name"
}