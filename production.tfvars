# production.tfvars
domain_name        = "www.jdnguyen.tech"
environment        = "production"
aws_s3_bucket_name = "www.jdnguyen.tech"
logs_bucket_name   = "log.jdnguyen.tech"
acm_certificate_arn = "arn:aws:acm:us-east-1:533267407336:certificate/c4dc3b71-4371-461c-a28c-1712afcb4c98"
cloudfront_price_class = "PriceClass_100"
allowed_countries      = ["US"]
