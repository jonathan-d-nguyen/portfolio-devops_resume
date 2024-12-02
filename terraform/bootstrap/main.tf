# terraform/bootstrap/main.tf

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# declare the data source to get current AWS account information
data "aws_caller_identity" "current" {}

# Variable for AWS profile name
variable "aws_profile" {
  description = "The AWS profile name being used for deployment"
  type        = string
}

locals {
  account_id = data.aws_caller_identity.current.account_id
  bucket_name = "jdnguyen-terraform-state-${var.aws_profile}"
  
  # Add debug information to be displayed in outputs
  debug_info = {
    account_id     = local.account_id
    caller_arn     = data.aws_caller_identity.current.arn
    user_id        = data.aws_caller_identity.current.user_id
    aws_profile    = var.aws_profile
    bucket_name    = local.bucket_name
  }
}

# Add outputs for debugging
output "deployment_info" {
  description = "Debug information about the current deployment"
  value = local.debug_info
}

# Create S3 bucket for Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = local.bucket_name
  lifecycle {
  # Prevent accidental deletion of this S3 bucket
    prevent_destroy = true
  }
}

# Enable versioning for state files
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# Add this to your bootstrap/main.tf

# CloudWatch Alarm for cost monitoring
resource "aws_cloudwatch_metric_alarm" "monthly_cost" {
  alarm_name          = "monthly-cost-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period             = "28800"  # 8 hours
  statistic          = "Maximum"
  threshold          = "1"      # $1 USD
  alarm_description  = "Alert when monthly costs exceed $1"
  alarm_actions      = [aws_sns_topic.cost_alerts.arn]

  dimensions = {
    Currency = "USD"
  }
}

# SNS Topic for cost alerts
resource "aws_sns_topic" "cost_alerts" {
  name = "cost-alerts"
}

# Note: After creating the SNS topic, you'll need to manually subscribe
# your email address through the AWS Console or use the AWS CLI

# Output the bucket name and DynamoDB table name
output "s3_bucket_name" {
  value       = aws_s3_bucket.terraform_state.id
  description = "The name of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "The name of the DynamoDB table"
}

