#!/bin/bash
# scripts/deploy.sh

set -euo pipefail

# Function to display usage
usage() {
    echo "Usage: $0 -p|--profile <aws_profile> [-e|--environment <environment>] [-i|--init-flags <terraform_init_flags>]"
    echo "Examples:"
    echo "  $0 -p account1 -e staging"
    echo "  $0 -p account2 -e production"
    echo "  $0 -p default -e staging -i '-reconfigure'"
    exit 1
}

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Go up one directory to get to the project root
PROJECT_ROOT="$( cd "${SCRIPT_DIR}/.." && pwd )"

# Initialize variables with defaults
INIT_FLAGS=""

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -p|--profile) AWS_PROFILE="$2"; shift ;;
        -e|--environment) ENVIRONMENT="$2"; shift ;;
        -i|--init-flags) INIT_FLAGS="$2"; shift ;;
        *) usage ;;
    esac
    shift
done

# Validate required arguments
if [ -z "$AWS_PROFILE" ]; then
    usage
fi

# Set environment to production if not specified
ENVIRONMENT=${ENVIRONMENT:-staging}

# # Debug information
# echo "Script directory: ${SCRIPT_DIR}"
# echo "Project root: ${PROJECT_ROOT}"
# echo "Environment: ${ENVIRONMENT}"
# echo "Looking for tfvars at: ${PROJECT_ROOT}/terraform/environments/${ENVIRONMENT}.tfvars"
# echo "Checking directory structure..."
# echo "- Project root: ${PROJECT_ROOT}"
# echo "- Terraform dir exists: $([[ -d "${PROJECT_ROOT}/terraform" ]] && echo "Yes" || echo "No")"
# echo "- Modules dir exists: $([[ -d "${PROJECT_ROOT}/terraform/modules" ]] && echo "Yes" || echo "No")"
# echo "- Website module exists: $([[ -d "${PROJECT_ROOT}/terraform/modules/website" ]] && echo "Yes" || echo "No")"
# echo "- Environments dir exists: $([[ -d "${PROJECT_ROOT}/terraform/environments" ]] && echo "Yes" || echo "No")"
# echo "- tfvars file exists: $([[ -f "${PROJECT_ROOT}/terraform/environments/${ENVIRONMENT}.tfvars" ]] && echo "Yes" || echo "No")"
# echo "- Backend config exists: $([[ -f "${PROJECT_ROOT}/terraform/backend-configs/${AWS_PROFILE}.hcl" ]] && echo "Yes" || echo "No")"

# # Debug Docker paths
# echo "Docker workspace paths:"
# echo "- Working directory: /workspace/terraform"
# echo "- Module path: /workspace/terraform/modules"
# echo "- Environment path: /workspace/terraform/environments"


# Ensure terraform directories exist
mkdir -p "${PROJECT_ROOT}/terraform/environments/${ENVIRONMENT}"
mkdir -p "${PROJECT_ROOT}/terraform/modules/website"
mkdir -p "${PROJECT_ROOT}/terraform/backend-configs"


# Copy main.tf to environment directory if it doesn't exist
if [ ! -f "${PROJECT_ROOT}/terraform/environments/${ENVIRONMENT}/main.tf" ]; then
    cp "${PROJECT_ROOT}/terraform/main.tf" "${PROJECT_ROOT}/terraform/environments/${ENVIRONMENT}/main.tf"
fi

# Check if tfvars file exists
if [ ! -f "${PROJECT_ROOT}/terraform/environments/${ENVIRONMENT}.tfvars" ]; then
    echo "Creating empty tfvars file..."
    touch "${PROJECT_ROOT}/terraform/environments/${ENVIRONMENT}.tfvars"
fi

# Check if backend config exists
if [ ! -f "${PROJECT_ROOT}/terraform/backend-configs/${AWS_PROFILE}.hcl" ]; then
    echo "Creating empty backend config..."
    touch "${PROJECT_ROOT}/terraform/backend-configs/${AWS_PROFILE}.hcl"
fi

# # Debug information
# echo "Project structure verification:"
# echo "------------------------------"
# ls -la "${PROJECT_ROOT}/terraform"
# echo "------------------------------"
# ls -la "${PROJECT_ROOT}/terraform/modules"
# echo "------------------------------"
# ls -la "${PROJECT_ROOT}/terraform/environments/${ENVIRONMENT}"

echo "Configuration:"
echo "- AWS Profile: ${AWS_PROFILE}"
echo "- Environment: ${ENVIRONMENT}"
echo "- Init Flags: ${INIT_FLAGS}"
echo "- Project Root: ${PROJECT_ROOT}"

## echo "Directory structure verification:"
# ls -la "${PROJECT_ROOT}/terraform/environments/${ENVIRONMENT}"
# ls -la "${PROJECT_ROOT}/terraform/modules/website"

# After parsing arguments but before directory setup
export AWS_PROFILE=$AWS_PROFILE

# First identity check - local environment
echo "Verifying AWS identity..."
if ! aws sts get-caller-identity; then
    echo "Error: Failed to get AWS identity. Please check your AWS credentials and profile."
    exit 1
fi
echo "Using AWS Profile: $AWS_PROFILE"

# Clean up any existing state if reconfigure is requested
if [[ "$INIT_FLAGS" == *"-reconfigure"* ]]; then
    echo "Reconfigure requested - cleaning up existing state..."
    rm -rf "${PROJECT_ROOT}/terraform/environments/${ENVIRONMENT}/.terraform"
    rm -f "${PROJECT_ROOT}/terraform/environments/${ENVIRONMENT}/.terraform.lock.hcl"
fi
# Second identity check - Docker context
echo "Verifying AWS identity in Docker context..."
if ! docker-compose run --rm aws sts get-caller-identity; then
    echo "Error: Failed to verify AWS identity in Docker context"
    exit 1
fi

# Proceed with Terraform operations only if both checks pass
echo "Initializing Terraform..."
docker-compose run --rm \
    -e AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY \
    -e AWS_SESSION_TOKEN \
    -e AWS_REGION="${AWS_REGION:-us-east-1}" \
    -v "${PROJECT_ROOT}/terraform:/workspace/terraform" \
    -w "/workspace/terraform/environments/${ENVIRONMENT}" \
    terraform init \
    -backend-config="/workspace/terraform/backend-configs/${AWS_PROFILE}.hcl" \
    ${INIT_FLAGS}

# Check if initialization was successful
if [ $? -ne 0 ]; then
    echo "Terraform initialization failed. Please check the errors above."
    exit 1
fi

# Apply Terraform with the correct variables
echo "Applying Terraform configuration..."
docker-compose run --rm \
    -e AWS_PROFILE="${AWS_PROFILE}" \
    -v "${PROJECT_ROOT}/terraform:/workspace/terraform" \
    -w "/workspace/terraform/environments/${ENVIRONMENT}" \
    terraform apply \
    -var-file="/workspace/terraform/environments/${ENVIRONMENT}.tfvars"