
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


locals {
  aws_s3_bucket_name = "www.jdnguyen.tech"
  domain = "www.jdnguyen.tech"
  logs_bucket_name   = "jdn.tech.log" 
  s3_origin_id = "myS3Origin"
  # hosted_zone_id = "(r53)"
  # cert_arn = "arn:"
}

provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
  default_tags {
    tags = {
      Environment = "staging"
      Project     = "personal-website"
    }
  }

  shared_config_files      = ["/home/tfuser/.aws/config"]
  shared_credentials_files = ["/home/tfuser/.aws/credentials"]
  profile                  = "default"
}

# S3 bucket for website
resource "aws_s3_bucket" "website" {
  bucket        = var.aws_s3_bucket_name
  force_destroy = true
}

# logging bucket
resource "aws_s3_bucket" "logs" {
  bucket = var.logs_bucket_name
  }

# Create CloudFront distribution
resource "aws_cloudfront_distribution" "main" {
  origin {
    domain_name              = aws_s3_bucket.website.bucket_domain_name
    origin_id                = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    
  }

  enabled             = true
  # aliases             = var.enable_custom_domain ? [var.domain_name] : []
  aliases = []  # Remove aliases temporarily

  default_root_object = "index.html"
  is_ipv6_enabled     = true
  wait_for_deployment = true


  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.logs.bucket_domain_name
    prefix          = "cloudfront-logs/"
  }
  
    price_class = var.cloudfront_price_class

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = var.allowed_countries
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

}

# Enable ACLs for the logging bucket
resource "aws_s3_bucket_ownership_controls" "logs" {
  bucket = aws_s3_bucket.logs.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Server side default encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "website" {
  bucket = aws_s3_bucket.website.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Grant permissions to CloudFront logging
resource "aws_s3_bucket_acl" "logs" {
  depends_on = [aws_s3_bucket_ownership_controls.logs]
  
  bucket = aws_s3_bucket.logs.id
  acl    = "private"
}

# Grant CloudFront logging permissions
resource "aws_s3_bucket_policy" "logs" {
  bucket = aws_s3_bucket.logs.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontLogDelivery"
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Action   = ["s3:PutObject"]
        Resource = ["${aws_s3_bucket.logs.arn}/*"]
      }
    ]
  })
}

# Creates the s3 bucket policy  
data "aws_iam_policy_document" "bucket_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.website.arn}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.main.arn]
    }
  }
}

# Update S3 bucket policy to allow CloudFront access
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.website.arn}/*", 
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.main.arn
          }
        }
      }
    ]
  })
}

# attaches bucket policy to s3 bucket
# resource "aws_s3_bucket_policy" "bucket_policy" {
#   depends_on = [
#   aws_s3_bucket_public_access_block.example,
#   aws_cloudfront_distribution.main
#   ]
#   bucket = aws_s3_bucket.website.id
#   policy = data.aws_iam_policy_document.bucket_policy.json
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

# Add website configuration for S3
resource "aws_s3_bucket_website_configuration" "www" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }
}

# Add bucket versioning (optional but recommended)
resource "aws_s3_bucket_versioning" "website" {
  bucket = aws_s3_bucket.website.id
  versioning_configuration {
    status = "Enabled"
  }
}

# For your website bucket, enable ACLs first
resource "aws_s3_bucket_ownership_controls" "website" {
  bucket = aws_s3_bucket.website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


# Then set the ACL
resource "aws_s3_bucket_acl" "website_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.website]
  
  bucket = aws_s3_bucket.website.id
  acl    = "private"
}



resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create a CloudFront origin access control configuration
resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "${var.environment}-${var.domain_name}-oac"
  description                       = "Origin Access Control for ${var.domain_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_acm_certificate" "cert" {
  provider = aws.us-east-1
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}