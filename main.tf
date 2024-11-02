provider "aws" {
  region = "us-east-1" 
  shared_config_files      = ["/home/tfuser/.aws/config"]
  shared_credentials_files = ["/home/tfuser/.aws/credentials"]
  profile                  = "default"
}

module "website" {
  source = "./modules/website"

  # domain_name        = "www.jdnguyen.tech"
  # environment        = "production"
  # aws_s3_bucket_name = "XXXXXXXXXXXXXXXXX"
  # logs_bucket_name   = "XXXXXXXXXXXX"
  # 
  # enable_custom_domain    = true
  # acm_certificate_arn    = "arn:aws:acm:us-east-1:533267407336:certificate/c4dc3b71-4371-461c-a28c-1712afcb4c98"
  # cloudfront_price_class = "PriceClass_100"
  # allowed_countries      = ["US"]

  domain_name            = var.domain_name
  environment           = var.environment
  aws_s3_bucket_name    = var.aws_s3_bucket_name
  logs_bucket_name      = var.logs_bucket_name
  enable_custom_domain  = var.enable_custom_domain
  acm_certificate_arn   = var.acm_certificate_arn
  cloudfront_price_class = var.cloudfront_price_class
  allowed_countries     = var.allowed_countries

  providers = {
    aws = aws
  }
}

# resource "aws_s3_bucket" "website" {
#   bucket = var.domain_name
#   force_destroy = true
# }

# resource "aws_s3_bucket_policy" "bucket_policy" {
#   depends_on = [aws_s3_bucket_public_access_block.example]
#   bucket     = aws_s3_bucket.website.id
#   policy = jsonencode(
#     {
#       "Version" : "2012-10-17",
#       "Statement" : [
#         {
#           "Sid" : "PublicReadGetObject",
#           "Effect" : "Allow",
#           "Principal" : "*",
#           "Action" : "s3:GetObject",
#           "Resource" : "arn:aws:s3:::${aws_s3_bucket.website.id}/*"
#         }
#       ]
#     }
#   )
# }

# resource "aws_s3_bucket_website_configuration" "website" {
#   bucket = aws_s3_bucket.website.id
# 
#   index_document {
#     suffix = "index.html"
#   }
# }

# Update the policy document to use module outputs
data "aws_iam_policy_document" "bucket_policy" {
  statement {
    actions = ["s3:GetObject"]
    resources = [
      module.website.bucket_arn,
      "${module.website.bucket_arn}/*",
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

# resource "aws_s3_bucket_public_access_block" "example" {
#   bucket = aws_s3_bucket.website.id
# 
#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }

output "website_bucket_url" {
  value = module.website.website_endpoint
  }