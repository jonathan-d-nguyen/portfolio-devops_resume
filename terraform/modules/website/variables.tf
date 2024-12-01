# terraform/modules/website/variables.tf

# Core naming variables
variable "project_name" {
  description = "Base name of the project (e.g., jdnguyen-tech)"
  type        = string
  default     = "jdnguyen-tech"
}

variable "environment" {
  description = "The deployment environment (staging or production)"
  type        = string
}

# Domain configuration
variable "domain_name" {
  description = "The domain name for the website (e.g., www.jdnguyen.tech)"
  type        = string
  default     = "www.jdnguyen.tech"
}

# CloudFront and security configuration
variable "enable_custom_domain" {
  description = "Whether to enable custom domain and SSL"
  type        = bool
  default     = true
}

variable "acm_certificate_arn" {
  description = "ARN of ACM certificate for custom domain"
  type        = string
  default     = "arn:aws:acm:us-east-1:533267407336:certificate/c4dc3b71-4371-461c-a28c-1712afcb4c98"
}

variable "cloudfront_price_class" {
  description = "CloudFront distribution price class"
  type        = string
  default     = "PriceClass_100"
}

variable "allowed_countries" {
  description = "List of countries allowed to access the distribution"
  type        = list(string)
  default     = ["US", "CA", "GB", "DE"]
}

# Local variable configurations for consistent naming
locals {
  # Base naming convention
  resource_prefix = "${var.environment}-${var.project_name}"
  
  # Resource names using consistent pattern
  website_bucket_name = local.resource_prefix
  logs_bucket_name    = "${local.resource_prefix}-logs"
  
  # Domain names - handles both staging and production scenarios
  website_domain = var.environment == "prod" ? var.domain_name : "${var.environment}.${var.project_name}"
  
  # Tags that should be applied to all resources
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# Remove the separate aws_s3_bucket_name and logs_bucket_name variables since 
# they're now handled by locals

# variable "aws_s3_bucket_name" {
#   description = "Name of the S3 bucket for the website"
#   type        = string
# }

# variable "logs_bucket_name" {
#   description = "Name of the S3 bucket for logs"
#   type        = string
#   default = "logs-jdnguyen.tech"
# }