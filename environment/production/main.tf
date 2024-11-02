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
  acm_certificate_arn    = "arn:aws:acm:us-east-1:533267407336:certificate/c4dc3b71-4371-461c-a28c-1712afcb4c98"
  cloudfront_price_class = "PriceClass_100"
  allowed_countries      = ["US"]
}
