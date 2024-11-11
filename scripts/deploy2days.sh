#!/bin/bash
set -e

ENVIRONMENT=$1

if [ -z "$ENVIRONMENT" ]; then
    echo "Usage: ./scripts/deploy_website.sh <environment>"
    exit 1
fi

# Deploy to appropriate S3 bucket
if [ "$ENVIRONMENT" = "staging" ]; then
    echo "Uploading files to staging..."
    aws s3 sync website_files/ s3://staging.jdnguyen.tech

    # Only invalidate CloudFront if we can get the distribution ID
    if [ -d "environments/staging" ]; then
        echo "Invalidating CloudFront cache..."
        cd environments/staging
        DIST_ID=$(terraform output -raw cloudfront_distribution_id)
        if [ ! -z "$DIST_ID" ]; then
            aws cloudfront create-invalidation --distribution-id $DIST_ID --paths "/*"
        else
            echo "Warning: Could not get CloudFront distribution ID. Skipping cache invalidation."
        fi
        cd ../..
    else
        echo "Warning: Staging environment directory not found. Skipping cache invalidation."
    fi
elif [ "$ENVIRONMENT" = "production" ]; then
    echo "Uploading files to production..."
    aws s3 sync website_files/ s3://www.jdnguyen.tech

    # Only invalidate CloudFront if we can get the distribution ID
    if [ -d "environments/production" ]; then
        echo "Invalidating CloudFront cache..."
        cd environments/production
        DIST_ID=$(terraform output -raw cloudfront_distribution_id)
        if [ ! -z "$DIST_ID" ]; then
            aws cloudfront create-invalidation --distribution-id $DIST_ID --paths "/*"
        else
            echo "Warning: Could not get CloudFront distribution ID. Skipping cache invalidation."
        fi
        cd ../..
    else
        echo "Warning: Production environment directory not found. Skipping cache invalidation."
    fi
else
    echo "Invalid environment. Use 'staging' or 'production'"
    exit 1
fi

echo "Deployment to $ENVIRONMENT complete!"
