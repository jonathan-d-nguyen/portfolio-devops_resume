# terraform/backend/main.tf
# Infrastructure setup with intelligent handling of existing resources
# Uses try() for safer existence checking

provider "aws" {
  region = "us-east-1"
}

locals {
  dynamodb_table_name = "terraform-state-locks"
  state_bucket_name   = "your-company-terraform-state"
}

# Check for existing DynamoDB table using a null resource
resource "null_resource" "check_dynamodb" {
  provisioner "local-exec" {
    command = <<-EOF
      if aws dynamodb describe-table --table-name ${local.dynamodb_table_name} 2>/dev/null; then
        echo "DynamoDB table exists"
        echo "To import: terraform import aws_dynamodb_table.terraform_locks ${local.dynamodb_table_name}"
        exit 1
      fi
    EOF
  }
}

# Check for existing S3 bucket using a null resource
resource "null_resource" "check_s3" {
  provisioner "local-exec" {
    command = <<-EOF
      if aws s3api head-bucket --bucket ${local.state_bucket_name} 2>/dev/null; then
        echo "S3 bucket exists"
        echo "To import: terraform import aws_s3_bucket.terraform_state ${local.state_bucket_name}"
        exit 1
      fi
    EOF
  }
}

# DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  depends_on = [null_resource.check_dynamodb]
  
  name         = local.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Description = "DynamoDB table for Terraform state locking"
    ManagedBy   = "terraform"
  }
}

# S3 bucket for state storage
resource "aws_s3_bucket" "terraform_state" {
  depends_on = [null_resource.check_s3]
  
  bucket = local.state_bucket_name

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Description = "S3 bucket for Terraform state storage"
    ManagedBy   = "terraform"
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}