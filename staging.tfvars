# staging.tfvars
environment        = "staging"
region             = "us-east-1"
domain_name        = "staging.jdnguyen.tech"
aws_s3_bucket_name = "staging-jdnguyen.tech"
logs_bucket_name   = "staging-jdnguyen.log"
enable_custom_domain = true
acm_certificate_arn = "arn:aws:acm:us-east-1:533267407336:certificate/c4dc3b71-4371-461c-a28c-1712afcb4c98"
cloudfront_price_class = "PriceClass_100"
allowed_countries    = ["US", "CA"]
