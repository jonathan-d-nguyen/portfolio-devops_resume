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


output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.main.domain_name
}

output "website_bucket_arn" {
  value = aws_s3_bucket.website.arn
}

output "cloudfront_distribution_domain" {
  value       = aws_cloudfront_distribution.main.domain_name
  description = "Domain name of CloudFront distribution"
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
