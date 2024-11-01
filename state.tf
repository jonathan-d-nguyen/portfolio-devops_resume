# First, create the S3 bucket and DynamoDB table (save this in a separate tf file)
# state.tf


# create s3 bucket for state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "jdnguyen-terraform-state"

  # Prevents Terraform from destroying this bucket, and all objects in it
  lifecycle {
    prevent_destroy = true
  }
}

# enable versioning on the bucket
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# enable encryption on the bucket
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

# create dynamodb table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# Output the bucket name and DynamoDB table
output "s3_bucket_name" {
  value = aws_s3_bucket.terraform_state.id
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
}

# Create the IAM role for Terraform state management
resource "aws_iam_role" "terraform_state_role" {
  name = "terraform-state-management"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Create the IAM policy for Terraform state management
resource "aws_iam_policy" "terraform_state_policy" {
  name        = "terraform-state-management"
  description = "Policy for Terraform state management"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::jdnguyen-terraform-state",
          "arn:aws:s3:::jdnguyen-terraform-state/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        Resource = "arn:aws:dynamodb:us-east-1:*:table/terraform-state-locks"
      }
    ]
  })
}

# Attach the policy to your IAM user 
# resource "aws_iam_user_policy_attachment" "terraform_state_policy_attach" {
#   user       = "YOUR_IAM_USERNAME"  # Replace with your IAM username
#   policy_arn = aws_iam_policy.terraform_state_policy.arn
# }

# Attach the policy to your IAM role
resource "aws_iam_role_policy_attachment" "terraform_state_policy_attach" {
  role       = aws_iam_role.terraform_state_role.name
  policy_arn = aws_iam_policy.terraform_state_policy.arn
}
