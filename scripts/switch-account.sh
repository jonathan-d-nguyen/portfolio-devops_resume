#!/bin/bash
# scripts/switch-account.sh

# Get the list of available profiles
profiles=$(aws configure list-profiles)

# If no profile was specified, show the menu
if [ -z "$1" ]; then
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

# Create a .env file for Docker Compose
echo "AWS_PROFILE=$profile" > .env

echo "Switched to AWS Profile: $profile"