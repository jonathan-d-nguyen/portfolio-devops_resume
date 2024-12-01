# terraform/environments/production/iam.tf

module "terraform_iam" {
  source = "../../modules/iam"

  environment        = "production"
  state_bucket_name  = "jdnguyen-terraform-state"
  dynamo_table_name  = "terraform-state-locks"
  trusted_role_arns  = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/DeploymentRole",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/admin"
  ]

  common_tags = {
    Environment = "production"
    Project     = "personal-website"
    ManagedBy   = "terraform"
  }
}

data "aws_caller_identity" "current" {}