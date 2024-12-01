# terraform/modules/iam/main.tf

# Create a policy for Terraform state management with environment-specific resources
resource "aws_iam_policy" "terraform_state_access" {
  name        = "${var.environment}-terraform-state-access"
  description = "Policy for Terraform state management in ${var.environment}"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.state_bucket_name}"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          # Allow access to environment-specific state files only
          "arn:aws:s3:::${var.state_bucket_name}/${var.environment}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        Resource = [
          "arn:aws:dynamodb:*:*:table/${var.dynamo_table_name}"
        ]
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name        = "${var.environment}-terraform-state-access"
    Environment = var.environment
  })
}

# Create a role that can be assumed for Terraform operations
resource "aws_iam_role" "terraform_state_role" {
  name = "${var.environment}-terraform-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.trusted_role_arns
        }
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name        = "${var.environment}-terraform-role"
    Environment = var.environment
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "terraform_state_policy_attach" {
  role       = aws_iam_role.terraform_state_role.name
  policy_arn = aws_iam_policy.terraform_state_access.arn
}

# Create environment-specific group
resource "aws_iam_group" "terraform_users" {
  name = "${var.environment}-terraform-users"
}

# Attach the policy to the group
resource "aws_iam_group_policy_attachment" "terraform_users_policy_attach" {
  group      = aws_iam_group.terraform_users.name
  policy_arn = aws_iam_policy.terraform_state_access.arn
}