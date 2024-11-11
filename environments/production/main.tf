# environments/production/main.tf
terraform {
  backend "s3" {
    bucket         = "jdnguyen-terraform-state"
    key            = "production/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
  
  default_tags {
    tags = {
      Environment = "production"
      Project     = "personal-website"
    }
  }
}

module "website" {
  source = "../../modules/website"

  domain_name        = "www.jdnguyen.tech"
  environment        = "production"
  aws_s3_bucket_name = "www.jdnguyen.tech"
  logs_bucket_name   = "log.jdnguyen.tech"
  
  enable_custom_domain    = true
  acm_certificate_arn     = "arn:aws:acm:us-east-1:533267407336:certificate/dcf1949e-7b8c-460e-b15e-7bb3cc136e96"
  cloudfront_price_class  = "PriceClass_100"
  allowed_countries       = ["US"]
}

output "cloudfront_distribution_id" {
  value = module.website.cloudfront_distribution_id
  description = "The CloudFront distribution ID"
}

output "cloudfront_domain_name" {
  value = module.website.cloudfront_domain_name
  description = "The CloudFront distribution domain name"
}
