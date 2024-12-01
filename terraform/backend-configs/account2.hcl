# terraform/backend-configs/account2.hcl
bucket         = "account2-terraform-state"
key            = "resume/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-state-locks"