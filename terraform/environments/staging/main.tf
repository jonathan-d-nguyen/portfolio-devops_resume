# terraform/environments/staging/main.tf

terraform {
  backend "s3" {
    bucket         = "jdnguyen-terraform-state"
    key            = "staging/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
  
  default_tags {
    tags = {
      Environment = "staging"
      Project     = "personal-website"
    }
  }
}

module "website" {
  # Use relative path from this directory to the modules directory
  source = "../../modules/website"

  # Primary website resources
  environment         = "staging"
  project_name        = "jdnguyen-tech"
  # domain_name         = "staging-jdnguyen-tech"
  # aws_s3_bucket_name  = "staging-jdnguyen-tech"
  # logs_bucket_name    = "staging-jdnguyen-tech-logs"
  # enable_custom_domain = true
  # acm_certificate_arn  = "arn:aws:acm:us-east-1:533267407336:certificate/c4dc3b71-4371-461c-a28c-1712afcb4c98"
  # cloudfront_price_class = "PriceClass_100"
  # allowed_countries    = ["US"]
}