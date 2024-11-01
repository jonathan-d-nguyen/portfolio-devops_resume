# environments/staging/main.tf
terraform {
  backend "s3" {
    bucket         = "jdnguyen-terraform-state"
    key            = "staging/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

locals {
  environment = "staging"
  domain_name = "staging.jdnguyen.tech"
}


# Create a CloudFront origin access control configuration
resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "default"
  description                       = "Default configuration for origin access control"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

module "website" {
  source = "../../modules/website"

  environment         = local.environment
  domain_name        = local.domain_name
  aws_s3_bucket_name = "${local.environment}-www.jdnguyen.tech"
  logs_bucket_name   = "${local.environment}-jdn.tech.logs"
  
  enable_custom_domain = false # use CloudFront default domain for staging
  
  cloudfront_price_class = "PriceClass_100"  # Cheaper for staging
  allowed_countries     = ["US"]  # Restrict to US only for staging

  # Add any additional variables as needed
}

# module "website" {
#   source = "../../modules/website"  # Path to your module
# 
#   domain_name        = "staging.jdnguyen.tech"
#   environment        = "staging"
#   aws_s3_bucket_name = "staging-www.jdnguyen.tech"
#   logs_bucket_name   = "staging-jdn.tech.log"
#   
#   enable_custom_domain    = false  # Use CloudFront default domain for staging
#   cloudfront_price_class = "PriceClass_100"  # Cheaper tier for staging
#   allowed_countries      = ["US"]  # Restrict staging to US only
# }
# 

############################################

# modules/website/main.tf

# Your existing main.tf code goes here, but using the variables

# provider "aws" {
#   region = "us-east-1" 
# 
#   shared_config_files      = ["/home/tfuser/.aws/config"]
#   shared_credentials_files = ["/home/tfuser/.aws/credentials"]
#   profile                  = "default"
# }

# 
# 
# # S3 bucket for website
# resource "aws_s3_bucket" "website" {
#   bucket = local.aws_s3_bucket_name
#   force_destroy = true
# }
# 
# # logging bucket
# resource "aws_s3_bucket" "logs" {
#   bucket = local.logs_bucket_name
#   }
# 
# # Create a CloudFront distribution
# resource "aws_cloudfront_distribution" "main" {
#   origin {
#     domain_name              = aws_s3_bucket.website.bucket_regional_domain_name
#     origin_access_control_id = aws_cloudfront_origin_access_control.default.id
#     origin_id                = local.s3_origin_id
#   }
# 
#   enabled             = true
# 
#   # needs cert before using custom CNAME
#   # aliases = [local.domain]
#   default_root_object = "index.html"
#   is_ipv6_enabled     = true
#   wait_for_deployment = true
# 
# 
#   default_cache_behavior {
#     allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
#     cached_methods   = ["GET", "HEAD"]
#     target_origin_id = local.s3_origin_id
#     forwarded_values {
#       query_string = false
# 
#       cookies {
#         forward = "none"
#       }
#     }
# 
#     viewer_protocol_policy = "redirect-to-https"
#     min_ttl                = 0
#     default_ttl            = 3600
#     max_ttl                = 86400
#   }
# 
#   logging_config {
#     include_cookies = false
#     bucket          = aws_s3_bucket.logs.bucket_domain_name
#     prefix          = "cloudfront-logs/"
#   }
#   
#   # Cache behavior with precedence 0
#   ordered_cache_behavior {
#     path_pattern     = "/content/immutable/*"
#     allowed_methods  = ["GET", "HEAD", "OPTIONS"]
#     cached_methods   = ["GET", "HEAD", "OPTIONS"]
#     target_origin_id = local.s3_origin_id
# 
#     forwarded_values {
#       query_string = false
#       headers      = ["Origin"]
# 
#       cookies {
#         forward = "none"
#       }
#     }
# 
#     min_ttl                = 0
#     default_ttl            = 86400
#     max_ttl                = 31536000
#     compress               = true
#     viewer_protocol_policy = "redirect-to-https"
#   }
# 
#   # Cache behavior with precedence 1
#   ordered_cache_behavior {
#     path_pattern     = "/content/*"
#     allowed_methods  = ["GET", "HEAD", "OPTIONS"]
#     cached_methods   = ["GET", "HEAD"]
#     target_origin_id = local.s3_origin_id
# 
#     forwarded_values {
#       query_string = false
# 
#       cookies {
#         forward = "none"
#       }
#     }
# 
#     min_ttl                = 0
#     default_ttl            = 3600
#     max_ttl                = 86400
#     compress               = true
#     viewer_protocol_policy = "redirect-to-https"
#   }
# 
#   price_class = "PriceClass_200"
# 
#   restrictions {
#     geo_restriction {
#       restriction_type = "whitelist"
#       locations        = ["US", "CA", "GB", "DE"]
#     }
#   }
# 
#   tags = {
#     Environment = "production"
#   }
# 
#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }
# }
# # Enable ACLs for the logging bucket
# resource "aws_s3_bucket_ownership_controls" "logs" {
#   bucket = aws_s3_bucket.logs.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }
# 
# # Server side default encryption
# resource "aws_s3_bucket_server_side_encryption_configuration" "website" {
#   bucket = aws_s3_bucket.website.id
#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }
# 
# # Grant permissions to CloudFront logging
# resource "aws_s3_bucket_acl" "logs" {
#   depends_on = [aws_s3_bucket_ownership_controls.logs]
#   
#   bucket = aws_s3_bucket.logs.id
#   acl    = "private"
# }
# 
# # Grant CloudFront logging permissions
# resource "aws_s3_bucket_policy" "logs" {
#   bucket = aws_s3_bucket.logs.id
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "AllowCloudFrontLogDelivery"
#         Effect = "Allow"
#         Principal = {
#           Service = "delivery.logs.amazonaws.com"
#         }
#         Action   = ["s3:PutObject"]
#         Resource = ["${aws_s3_bucket.logs.arn}/*"]
#       }
#     ]
#   })
# }
# 
# # Creates the s3 bucket policy  
# data "aws_iam_policy_document" "bucket_policy" {
#   statement {
#     principals {
#       type        = "Service"
#       identifiers = ["cloudfront.amazonaws.com"]
#     }
# 
#     actions = [
#       "s3:GetObject"
#     ]
# 
#     resources = [
#       "${aws_s3_bucket.website.arn}/*"
#     ]
#     condition {
#       test     = "StringEquals"
#       variable = "AWS:SourceArn"
#       values   = [aws_cloudfront_distribution.main.arn]
#     }
#   }
# }
# 
# # attaches bucket policy to s3 bucket
# resource "aws_s3_bucket_policy" "bucket_policy" {
#   depends_on = [
#   aws_s3_bucket_public_access_block.example,
#   aws_cloudfront_distribution.main
#   ]
#   bucket = aws_s3_bucket.website.id
#   policy = data.aws_iam_policy_document.bucket_policy.json
# }
# 
# # resource "aws_s3_bucket_policy" "bucket_policy" {
# #   depends_on = [aws_s3_bucket_public_access_block.example]
# #   bucket     = aws_s3_bucket.website.id
# #   policy = jsonencode(
# #     {
# #       "Version" : "2012-10-17",
# #       "Statement" : [
# #         {
# #           "Sid" : "PublicReadGetObject",
# #           "Effect" : "Allow",
# #           "Principal" : "*",
# #           "Action" : "s3:GetObject",
# #           "Resource" : "arn:aws:s3:::${aws_s3_bucket.website.id}/*"
# #         }
# #       ]
# #     }
# #   )
# # }
# 
# resource "aws_s3_bucket_website_configuration" "website" {
#   bucket = aws_s3_bucket.website.id
# 
#   index_document {
#     suffix = "index.html"
#   }
# }
# 
# # For your website bucket, enable ACLs first
# resource "aws_s3_bucket_ownership_controls" "website" {
#   bucket = aws_s3_bucket.website.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }
# 
# 
# # Then set the ACL
# resource "aws_s3_bucket_acl" "website_acl" {
#   depends_on = [aws_s3_bucket_ownership_controls.website]
#   
#   bucket = aws_s3_bucket.website.id
#   acl    = "private"
# }
# 
# 
# 
# resource "aws_s3_bucket_public_access_block" "example" {
#   bucket = aws_s3_bucket.website.id
# 
#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }
# 
# # Output the CloudFront distribution URL
# output "website_bucket_url" {
#   value = aws_s3_bucket_website_configuration.website.website_endpoint
# }
# 
# 
# resource "aws_acm_certificate" "cert" {
#   provider = aws.us-east-1
#   domain_name       = local.domain_name
#   validation_method = "DNS"
# 
#   lifecycle {
#     create_before_destroy = true
#   }
# }