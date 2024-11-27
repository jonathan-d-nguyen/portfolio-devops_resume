# modules/website/outputs.tf
# Output configuration for DNS records needed at third-party registrar
# Structured to show all required DNS records for domain setup


# Output the CloudFront distribution URL
output "website_bucket_url" {
  value = aws_s3_bucket_website_configuration.www.website_endpoint
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.main.id
  description = "The CloudFront distribution ID"
}

# output "cloudfront_distribution_id" {
#   value = aws_cloudfront_distribution.website_cdn.id
# }

output "website_bucket_arn" {
  value = aws_s3_bucket.website.arn
}

output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.main.domain_name
  description = "CloudFront distribution domain for DNS CNAME/ALIAS records"
}

output "website_bucket_name" {
  value       = aws_s3_bucket.website.id
  description = "Name of the website S3 bucket"
}

output "logs_bucket_name" {
  value       = aws_s3_bucket.logs.id
  description = "Name of the logs S3 bucket"
}

output "bucket_arn" {
  value = aws_s3_bucket.website.arn
}
output "acm_validation_records" {
  value = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      value  = dvo.resource_record_value
    }
  }
  description = "DNS records required for ACM certificate validation"
}

output "dns_configuration_summary" {
  value = <<EOF
DNS Records Required for Domain Configuration at Joker.com:

1. Main domain (www.jdnguyen.tech):
   Type: CNAME
   Name: www
   Value: ${aws_cloudfront_distribution.main.domain_name}

2. Certificate Validation Records:
   ${join("\n   ", [
     for dvo in aws_acm_certificate.cert.domain_validation_options : 
     "Type: ${dvo.resource_record_type}, Name: ${dvo.resource_record_name}, Value: ${dvo.resource_record_value}"
   ])}

Note: Create these records at joker.com to complete domain and SSL certificate setup.
EOF
  description = "Summary of all required DNS records in human-readable format"
}