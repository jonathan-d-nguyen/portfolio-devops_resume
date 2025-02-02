#!/bin/bash
# scripts/switch-account.sh
set -euo pipefail

# Get the list of available profiles
profiles=$(aws configure list-profiles)

# If no profile was specified or script is being sourced, show the menu
if [ ${1:-""} = "" ]; then
    echo "Available AWS Profiles:"
    echo "$profiles" | nl
    echo "Select profile number: "
    read selection
    profile=$(echo "$profiles" | sed -n "${selection}p")
else
    profile=$1
fi

# Export the selected profile
export AWS_PROFILE=$profile

# Determine environment based on profile
case $profile in
    "account1-prod")
        environment="production"
        ;;
    "account2-dev"|"default")
        environment="staging"
        ;;
    *)
        environment="staging"
        ;;
esac

# Create/update .env file for Docker Compose with proper quoting
cat > .env << EOF
AWS_PROFILE="${profile}"
ENVIRONMENT="${environment}"
EOF

# Get account info for verification
account_info=$(aws sts get-caller-identity)
account_id=$(echo $account_info | jq -r .Account)
account_arn=$(echo $account_info | jq -r .Arn)

# Export for shell session
export ENVIRONMENT="$environment"
export AWS_ACCOUNT_ID="$account_id"

echo "Switched to:"
echo "- AWS Profile: $profile"
echo "- Environment: $environment"
echo "- Account ID: $account_id"
echo "- ARN: $account_arn"