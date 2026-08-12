#!/bin/bash
# scripts/deploy_website.sh
# Syncs website_files/ to the environment's S3 bucket and invalidates its
# CloudFront cache. The distribution ID is resolved by its domain alias, so
# no terraform state or working directory is required.
#
# Usage: ./scripts/deploy_website.sh <staging|production>
# Deps:  aws cli (authenticated), an active AWS profile/credentials.
set -euo pipefail

ENVIRONMENT="${1:-}"

if [ -z "$ENVIRONMENT" ]; then
    echo "Usage: ./scripts/deploy_website.sh <staging|production>"
    exit 1
fi

# Map environment -> bucket / domain alias
case "$ENVIRONMENT" in
    staging)
        BUCKET="staging.jdnguyen.tech"
        DOMAIN="staging.jdnguyen.tech"
        ;;
    production)
        BUCKET="www.jdnguyen.tech"
        DOMAIN="www.jdnguyen.tech"
        ;;
    *)
        echo "Invalid environment. Use 'staging' or 'production'"
        exit 1
        ;;
esac

# Resolve repo root so the script works from any working directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Deploy source: the Modernist portfolio (website_v2/), which serves the
# public site at / and the digital business card at /card/. The legacy
# website_files/ card lives on only as a reference until it is removed.
echo "Uploading files to $ENVIRONMENT (s3://$BUCKET)..."
aws s3 sync "$REPO_ROOT/website_v2/" "s3://$BUCKET" \
    --delete \
    --exclude ".DS_Store" \
    --exclude "*/.DS_Store" \
    --exclude "*copy*" \
    --exclude "*.md" \
    --exclude ".git/*"

echo "Resolving CloudFront distribution for $DOMAIN..."
DIST_ID=$(aws cloudfront list-distributions \
    --query "DistributionList.Items[?Aliases.Items[?@=='$DOMAIN']].Id | [0]" \
    --output text)

if [ -n "$DIST_ID" ] && [ "$DIST_ID" != "None" ]; then
    echo "Invalidating CloudFront cache ($DIST_ID)..."
    aws cloudfront create-invalidation --distribution-id "$DIST_ID" --paths "/*"
else
    echo "Warning: No CloudFront distribution found with alias '$DOMAIN'. Skipping cache invalidation."
fi

echo "Deployment to $ENVIRONMENT complete!"
