# main.tf (root level)
# This is the entry point for our Terraform configuration
# It sets up the AWS provider and defines high-level project settings

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # If you're using remote state, uncomment and configure this block
  # backend "s3" {
  #   # Configure your backend settings here
  # }
}

provider "aws" {
  region = "us-east-1" 
  # shared_config_files      = ["/home/tfuser/.aws/config"]
  # shared_credentials_files = ["/home/tfuser/.aws/credentials"]
  # profile                  = "default"

  default_tags {
    tags = {
      Project     = "DevOps Portfolio"
      ManagedBy   = "Terraform"
      Repository  = "portfolio-devops_resume"
    }
  }
}

# Define any global variables or data sources here
variable "project_name" {
  description = "The name of the project, used for resource naming"
  type        = string
  default     = "jdnguyen-tech"
}

variable "environment" {
  description = "The deployment environment (staging or production)"
  type        = string
}

# You might want to load environment-specific variables
locals {
  env_config = {
    production = {
      domain_name = "www.jdnguyen.tech"
      enable_custom_domain = true
    }
    staging = {
      domain_name = "staging.jdnguyen.tech"
      enable_custom_domain = true
    }
  }
}
# module "website" {
#   source = "./terraform/modules/website"
# 
#   domain_name            = var.domain_name
#   environment           = var.environment
#   # aws_s3_bucket_name    = var.aws_s3_bucket_name
#   # logs_bucket_name      = var.logs_bucket_name
#   enable_custom_domain  = var.enable_custom_domain
#   acm_certificate_arn   = var.acm_certificate_arn
#   cloudfront_price_class = var.cloudfront_price_class
#   allowed_countries     = var.allowed_countries
# 
#   providers = {
#     aws = aws
#   }
# }


# Update the policy document to use module outputs
# data "aws_iam_policy_document" "bucket_policy" {
#   statement {
#     actions = ["s3:GetObject"]
#     resources = [
#       module.website.bucket_arn,
#       "${module.website.bucket_arn}/*",
#     ]
#     principals {
#       type        = "*"
#       identifiers = ["*"]
#     }
#   }
# }
# 
# 
# output "website_bucket_url" {
#   value = module.website.website_bucket_url
#   }
# 
# output "cloudfront_distribution_id" {
#   value = module.website.cloudfront_distribution_id
# }
