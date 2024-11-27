# terraform/backend-configs/account1.hcl
bucket         = "account1-terraform-state"
key            = "resume/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-state-locks"