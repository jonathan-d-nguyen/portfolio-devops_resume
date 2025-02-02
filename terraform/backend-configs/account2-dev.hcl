# terraform/backend-configs/account2-dev.hcl
bucket         = "jdnguyen-terraform-state-dev"
key            = "staging/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-state-locks"
encrypt        = true