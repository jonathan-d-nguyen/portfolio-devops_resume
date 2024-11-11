provider "aws" {
  region = "us-east-1" 
  shared_config_files      = ["/home/tfuser/.aws/config"]
  shared_credentials_files = ["/home/tfuser/.aws/credentials"]
  profile                  = "default"
}

module "website" {
  source = "./modules/website"

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


output "website_bucket_url" {
  value = module.website.website_bucket_url
  }

output "cloudfront_distribution_id" {
  value = module.website.cloudfront_distribution_id
}
