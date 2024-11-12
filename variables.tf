variable "domain_name" {
  description = "The name of the domain for our website"
  type        = string
  default = "www.jdnguyen.tech"
}

variable "environment" {
  description = "Environment (staging or production)"
  type        = string
}

variable "aws_s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default = "www.jdnguyen.tech"
}

variable "logs_bucket_name" {
  description = "Name of the S3 bucket for logs"
  type        = string
  default = "log.jdnguyen.tech"
}

variable "enable_custom_domain" {
  description = "Enable custom domain for CloudFront"
  type        = bool
  default = true
}

variable "acm_certificate_arn" {
  description = "ARN of ACM certificate"
  type        = string
  default = "arn:aws:acm:us-east-1:533267407336:certificate/c4dc3b71-4371-461c-a28c-1712afcb4c98"
}

variable "cloudfront_price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
}

variable "allowed_countries" {
  description = "List of allowed countries for CloudFront distribution"
  type        = list(string)
  default     = ["US"]
}
