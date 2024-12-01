# terraform/modules/iam/variables.tf

variable "environment" {
  description = "Environment name (staging or production)"
  type        = string
  
  validation {
    condition     = contains(["staging", "production"], var.environment)
    error_message = "Environment must be either 'staging' or 'production'."
  }
}

variable "state_bucket_name" {
  description = "Name of the S3 bucket storing Terraform state"
  type        = string
}

variable "dynamo_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
}

variable "trusted_role_arns" {
  description = "List of ARNs that can assume the Terraform role"
  type        = list(string)
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# terraform/modules/iam/outputs.tf
output "policy_arn" {
  description = "ARN of the created IAM policy"
  value       = aws_iam_policy.terraform_state_access.arn
}

output "role_arn" {
  description = "ARN of the created IAM role"
  value       = aws_iam_role.terraform_state_role.arn
}

output "group_name" {
  description = "Name of the created IAM group"
  value       = aws_iam_group.terraform_users.name
}