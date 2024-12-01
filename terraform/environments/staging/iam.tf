# terraform/environments/staging/iam.tf

module "terraform_iam" {
  source = "../../modules/iam"

  environment        = "staging"
  state_bucket_name  = "jdnguyen-terraform-state"
  dynamo_table_name  = "terraform-state-locks"
  trusted_role_arns  = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/account2-dev"
  ]

  common_tags = {
    Environment = "staging"
    Project     = "personal-website"
    ManagedBy   = "terraform"
  }
}

data "aws_caller_identity" "current" {}