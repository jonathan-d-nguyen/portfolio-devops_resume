# terraform/modules/base/variables.tf
# terraform/modules/base/variables.tf
# terraform/modules/base/variables.tf
# Create a base module for common configurations
variable "environment" {
  description = "The deployment environment (e.g., staging, production)"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}