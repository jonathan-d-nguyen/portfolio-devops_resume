#!/bin/bash
# terraform/bootstrap/deploy.sh

set -e  # Exit on any error

# Color codes for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print section headers
print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}\n"
}

# Function to print debug information
print_debug() {
    echo -e "${YELLOW}DEBUG: $1${NC}"
}

# Function to print errors
print_error() {
    echo -e "${RED}ERROR: $1${NC}"
}

# Ensure AWS profile is provided
if [ -z "$1" ]; then
    print_error "No AWS profile specified"
    echo "Usage: $0 <aws-profile>"
    echo "Example: $0 account2-dev"
    exit 1
fi

# Export the profile name for Terraform
export TF_VAR_aws_profile="$1"
export AWS_PROFILE="$1"

print_header "Deployment Configuration"
echo "AWS Profile: $AWS_PROFILE"

# Verify AWS credentials
print_header "Verifying AWS Credentials"
if aws sts get-caller-identity > /dev/null 2>&1; then
    ACCOUNT_INFO=$(aws sts get-caller-identity --output json)
    ACCOUNT_ID=$(echo $ACCOUNT_INFO | jq -r .Account)
    USER_ARN=$(echo $ACCOUNT_INFO | jq -r .Arn)
    
    echo -e "${GREEN}Successfully authenticated with AWS${NC}"
    print_debug "Account ID: $ACCOUNT_ID"
    print_debug "User ARN: $USER_ARN"
else
    print_error "Failed to authenticate with AWS using profile '$AWS_PROFILE'"
    exit 1
fi

# Check if we're running in the intended account
print_header "Account Verification"
read -p "Is this the intended AWS account ($ACCOUNT_ID)? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_error "Deployment cancelled - wrong account"
    exit 1
fi

# Initialize Terraform
print_header "Initializing Terraform"
terraform init

# Plan the changes
print_header "Planning Terraform Changes"
terraform plan -out=tfplan

# Confirm application
print_header "Ready to Apply Changes"
echo -e "Profile: ${YELLOW}$AWS_PROFILE${NC}"
echo -e "Account: ${YELLOW}$ACCOUNT_ID${NC}"
read -p "Do you want to proceed with the deployment? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_header "Applying Changes"
    terraform apply tfplan
    
    # Show outputs after successful application
    print_header "Deployment Outputs"
    terraform output
else
    print_error "Deployment cancelled by user"
    exit 1
fi