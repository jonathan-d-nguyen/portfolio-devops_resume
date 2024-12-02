#!/bin/bash
# terraform/bootstrap/verify-access.sh
# used for cross-account access verification

set -e

# Color codes for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}\n"
}

# Verify S3 bucket access
verify_s3_access() {
    local bucket_name=$1
    print_header "Verifying S3 Bucket Access: $bucket_name"
    
    if aws s3 ls "s3://$bucket_name" > /dev/null 2>&1; then
        echo -e "${GREEN}Successfully accessed bucket${NC}"
        aws s3api get-bucket-tagging --bucket "$bucket_name" 2>/dev/null || echo "No tags found"
    else
        echo -e "${RED}Failed to access bucket${NC}"
        return 1
    fi
}

# Verify DynamoDB access
verify_dynamodb_access() {
    local table_name=$1
    print_header "Verifying DynamoDB Table Access: $table_name"
    
    if aws dynamodb describe-table --table-name "$table_name" > /dev/null 2>&1; then
        echo -e "${GREEN}Successfully accessed table${NC}"
    else
        echo -e "${RED}Failed to access table${NC}"
        return 1
    fi
}

# Main verification logic
if [ -z "$1" ]; then
    echo "Usage: $0 <aws-profile>"
    exit 1
fi

export AWS_PROFILE="$1"
print_header "Running Access Verification with Profile: $AWS_PROFILE"

# Get account info
ACCOUNT_INFO=$(aws sts get-caller-identity --output json)
ACCOUNT_ID=$(echo $ACCOUNT_INFO | jq -r .Account)
USER_ARN=$(echo $ACCOUNT_INFO | jq -r .Arn)

echo "Account ID: $ACCOUNT_ID"
echo "User ARN: $USER_ARN"

# Verify access to resources
BUCKET_NAME="jdnguyen-terraform-state-$AWS_PROFILE"
verify_s3_access "$BUCKET_NAME"
verify_dynamodb_access "terraform-state-locks"