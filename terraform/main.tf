# terraform/main.tf
# This file configures the website module with environment-specific settings

# terraform/main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Backend configuration for storing state
  backend "s3" {
    bucket         = "jdnguyen-terraform-state"
    key            = "staging/terraform.tfstate"  # This will be overridden by backend config
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Project     = "DevOps Portfolio"
      ManagedBy   = "Terraform"
      Repository  = "portfolio-devops_resume"
    }
  }
}

# Reference the website module
module "website" {
  source = "/modules/website"

  # Core configuration
  environment   = var.environment
  project_name  = var.project_name
  domain_name   = local.env_config[var.environment].domain_name

  # Feature flags and security configuration
  enable_custom_domain     = local.env_config[var.environment].enable_custom_domain
  acm_certificate_arn     = "arn:aws:acm:us-east-1:533267407336:certificate/c4dc3b71-4371-461c-a28c-1712afcb4c98"
  cloudfront_price_class  = "PriceClass_100"
  allowed_countries       = ["US", "CA", "GB", "DE"]
}

# Output important values from the module
output "website_domain" {
  description = "The domain name of the website"
  value       = module.website.website_domain
}

output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution"
  value       = module.website.cloudfront_distribution_id
}

output "website_bucket_name" {
  description = "Name of the S3 bucket hosting the website"
  value       = module.website.website_bucket_name
}

output "logs_bucket_name" {
  description = "Name of the S3 bucket storing logs"
  value       = module.website.logs_bucket_name
}

# 
# provider "aws" {
#   region = "us-east-1" 
#   shared_config_files      = ["/home/tfuser/.aws/config"]
#   shared_credentials_files = ["/home/tfuser/.aws/credentials"]
#   profile                  = "default"
# }
# 
# module "website" {
#   source = "/modules/website"
# 
#   domain_name            = var.domain_name
#   project_name           = var.project_name
#   # environment           = var.environment
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
# 
# 
# # Update the policy document to use module outputs
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
