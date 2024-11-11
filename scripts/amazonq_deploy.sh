#!/bin/bash
set -e

ENVIRONMENT=$1
FORCE_INVALIDATE=$2

echo "Debug: Current directory: $(pwd)"
echo "Debug: ENVIRONMENT=$ENVIRONMENT"
echo "Debug: FORCE_INVALIDATE=$FORCE_INVALIDATE"
echo "Debug: Listing current directory contents:"
ls -la

if [ -z "$ENVIRONMENT" ]; then
    echo "Usage: ./scripts/amazonq_deploy.sh <environment> [force-invalidate]"
    exit 1
fi

# Function to find Terraform directory and perform invalidation
find_terraform_and_invalidate() {
    local env=$1
    local bucket=$2
    
    echo "Uploading files to $env..."
    aws s3 sync website_files/ s3://$bucket

    echo "Debug: Checking invalidation conditions for $env..."
    echo "Debug: FORCE_INVALIDATE=$FORCE_INVALIDATE"
    echo "Debug: Git status: $(git status --porcelain website_files/)"
    
    if [ "$FORCE_INVALIDATE" = "force-invalidate" ] || [ -n "$(git status --porcelain website_files/)" ]; then
        echo "Invalidating CloudFront cache for $env..."
        
        # Use the current directory as the Terraform directory
        TERRAFORM_DIR="."
        
        echo "Debug: Using Terraform directory: $TERRAFORM_DIR"
        
        # Initialize Terraform
        echo "Initializing Terraform..."
        terraform init

        if [ -f "terraform.tfstate" ]; then
            DIST_ID=$(terraform output -raw cloudfront_distribution_id)
            echo "Debug: DIST_ID=$DIST_ID"
            if [ ! -z "$DIST_ID" ]; then
                aws cloudfront create-invalidation --distribution-id $DIST_ID --paths "/*"
            else
                echo "Warning: Could not get CloudFront distribution ID for $env. Skipping cache invalidation."
            fi
        else
            echo "Error: terraform.tfstate file not found in $TERRAFORM_DIR"
            return 1
        fi
    else
        echo "No changes detected in website_files/ and force-invalidate not specified for $env. Skipping cache invalidation."
    fi
}

# Deploy to appropriate S3 bucket
if [ "$ENVIRONMENT" = "staging" ]; then
    find_terraform_and_invalidate "staging" "staging.jdnguyen.tech"
elif [ "$ENVIRONMENT" = "production" ]; then
    find_terraform_and_invalidate "production" "www.jdnguyen.tech"
else
    echo "Invalid environment. Use 'staging' or 'production'"
    exit 1
fi

echo "Deployment to $ENVIRONMENT complete!"
