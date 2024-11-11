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


# Default provider
provider "aws" {
  region = "us-east-1"
  
  default_tags {
    tags = {
      Environment = "staging"
      Project     = "personal-website"
    }
  }
}

# Additional provider specifically for ACM certificates
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
  
  default_tags {
    tags = {
      Environment = "staging"
      Project     = "personal-website"
    }
  }
}

module "website" {
  source = "../../modules/website"

providers = {
  aws = aws
}


  domain_name        = "staging.jdnguyen.tech"
  environment        = "staging"
  aws_s3_bucket_name = "staging.jdnguyen.tech"
  logs_bucket_name   = "staging.logs.jdnguyen.tech"
  
  enable_custom_domain    = true
  acm_certificate_arn    = "arn:aws:acm:us-east-1:533267407336:certificate/c4dc3b71-4371-461c-a28c-1712afcb4c98"
  cloudfront_price_class = "PriceClass_100"
  allowed_countries      = ["US"]
}

output "cloudfront_distribution_id" {
  value = module.website.cloudfront_distribution_id
  description = "The CloudFront distribution ID"
}
