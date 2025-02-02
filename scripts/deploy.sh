#!/bin/bash
# scripts/deploy.sh
set -euo pipefail

# Function to load environment from .env file
load_env() {
    if [ -f .env ]; then
        export $(cat .env | xargs)
    fi
}

# Check if we need to switch accounts
if [ -z "${AWS_PROFILE:-}" ] || [ -z "${ENVIRONMENT:-}" ]; then
    # Run switch-account.sh
    bash ./scripts/switch-account.sh
    # Load the environment variables it created
    load_env
fi

# Verify we have the required variables
if [ -z "${AWS_PROFILE:-}" ] || [ -z "${ENVIRONMENT:-}" ]; then
    echo "Error: Required environment variables not set"
    echo "AWS_PROFILE: ${AWS_PROFILE:-not set}"
    echo "ENVIRONMENT: ${ENVIRONMENT:-not set}"
    exit 1
fi

# Create required directories
mkdir -p terraform/backend-configs
mkdir -p terraform/environments

# Safeguard against production deployments
if [ "$ENVIRONMENT" = "production" ]; then
    echo "⚠️  WARNING: You're about to deploy to PRODUCTION ⚠️"
    echo "Account: ${AWS_ACCOUNT_ID:-unknown}"
    echo "Profile: $AWS_PROFILE"
    read -p "Are you absolutely sure? (type 'yes' to confirm): " confirmation
    if [ "$confirmation" != "yes" ]; then
        echo "Deployment cancelled"
        exit 1
    fi
fi

# Create backend config if it doesn't exist
BACKEND_CONFIG="terraform/backend-configs/${AWS_PROFILE}.hcl"
if [ ! -f "$BACKEND_CONFIG" ]; then
    echo "Creating backend config at $BACKEND_CONFIG..."
    cat > "$BACKEND_CONFIG" << EOF
bucket         = "jdnguyen-terraform-state-${AWS_PROFILE}"
key            = "${ENVIRONMENT}/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-state-locks"
encrypt        = true
EOF
fi

# Create environment tfvars if it doesn't exist
TFVARS_FILE="terraform/environments/${ENVIRONMENT}.tfvars"
if [ ! -f "$TFVARS_FILE" ]; then
    echo "Creating tfvars file at $TFVARS_FILE..."
    cat > "$TFVARS_FILE" << EOF
environment = "${ENVIRONMENT}"
region      = "us-east-1"
EOF
fi

# Deploy infrastructure using Docker Compose
echo "Deploying to $ENVIRONMENT environment using profile $AWS_PROFILE..."

echo "Initializing Terraform..."
docker compose run --rm \
    terraform init \
    -backend-config="/workspace/terraform/backend-configs/${AWS_PROFILE}.hcl"

echo "Planning Terraform changes..."
docker compose run --rm \
    terraform plan \
    -var-file="/workspace/terraform/environments/${ENVIRONMENT}.tfvars" \
    -out=tfplan

echo "Review the plan above."
read -p "Do you want to apply these changes? (yes/no): " apply_confirmation

if [ "$apply_confirmation" = "yes" ]; then
    echo "Applying changes..."
    docker compose run --rm \
        terraform apply tfplan
else
    echo "Deployment cancelled"
    exit 1
fi