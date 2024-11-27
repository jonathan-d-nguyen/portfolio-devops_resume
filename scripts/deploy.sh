# scripts/deploy.sh
#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 -p|--profile <aws_profile> [-e|--environment <environment>]"
    echo "Examples:"
    echo "  $0 -p account1 -e staging"
    echo "  $0 -p account2 -e production"
    exit 1
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -p|--profile) AWS_PROFILE="$2"; shift ;;
        -e|--environment) ENVIRONMENT="$2"; shift ;;
        *) usage ;;
    esac
    shift
done

# Validate required arguments
if [ -z "$AWS_PROFILE" ]; then
    usage
fi

# Set environment to production if not specified
ENVIRONMENT=${ENVIRONMENT:-production}

# Export AWS Profile
export AWS_PROFILE=$AWS_PROFILE

# Initialize Terraform with the correct backend config
docker-compose run --rm terraform init \
    -backend-config="terraform/backend-configs/${AWS_PROFILE}.hcl"

# Apply Terraform with the correct variables
docker-compose run --rm terraform apply \
    -var-file="terraform/environments/${ENVIRONMENT}.tfvars"