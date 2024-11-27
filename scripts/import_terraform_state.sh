# scripts/import_terraform_state.sh
#!/bin/bash

check_and_import_resource() {
    local resource_type=$1    # e.g., "aws_s3_bucket"
    local resource_name=$2    # e.g., "terraform_state"
    local resource_id=$3      # e.g., "your-company-terraform-state"
    local check_command=$4    # AWS CLI command to check resource existence
    
    echo "Checking ${resource_type}.${resource_name}..."
    
    # First, check if it's already in Terraform state
    if terraform state list | grep -q "${resource_type}.${resource_name}"; then
        echo "Resource is already in Terraform state."
        echo "Would you like to remove it and re-import? (y/n)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            echo "Removing from state..."
            terraform state rm "${resource_type}.${resource_name}"
        else
            echo "Skipping import."
            return
        fi
    fi
    
    # Now check if the resource exists in AWS
    if eval "$check_command" &>/dev/null; then
        echo "Found existing resource. Would you like to import it? (y/n)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            terraform import "${resource_type}.${resource_name}" "$resource_id"
        fi
    else
        echo "Resource does not exist in AWS."
    fi
}

# Check and import S3 bucket
check_and_import_resource \
    "aws_s3_bucket" \
    "terraform_state" \
    "your-company-terraform-state" \
    "aws s3api head-bucket --bucket your-company-terraform-state"

# Check and import DynamoDB table
check_and_import_resource \
    "aws_dynamodb_table" \
    "terraform_locks" \
    "terraform-state-locks" \
    "aws dynamodb describe-table --table-name terraform-state-locks"