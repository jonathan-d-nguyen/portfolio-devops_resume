variable "aws_s3_bucket_name" {
  description = "Name of the S3 bucket for the website"
  type        = string
}

variable "logs_bucket_name" {
  description = "Name of the S3 bucket for logs"
  type        = string
  default = "logs-jdnguyen.tech"
}

variable "environment" {
  description = "The deployment environment (staging or production)"
  type        = string
}

variable "domain_name" {
  default = "www.jdnguyen.tech"
  description = "The domain name for the website"
  type        = string
}

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
