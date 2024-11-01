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
  logs_bucket_name   = "jdn.tech.log"
  
  enable_custom_domain    = true
  acm_certificate_arn    = "arn:aws:acm:us-east-1:YOUR_ACCOUNT_ID:certificate/your-cert-id"
  cloudfront_price_class = "PriceClass_200"
  allowed_countries      = ["US", "CA", "GB", "DE"]
}
