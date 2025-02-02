# terraform/backend-configs/account1-prod.hcl
bucket         = "jdnguyen-terraform-state-prod"
key            = "production/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-state-locks"
encrypt        = true