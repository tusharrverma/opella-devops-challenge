variable "location" {
  type        = string
  default     = "westus"
  description = "Azure region for the prod environment"
}

variable "environment" {
  type        = string
  default     = "prod"
  description = "Environment name"
}