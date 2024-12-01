#!/bin/bash
# terraform/scripts/deploy-with-profile.sh
source ./switch-account.sh
./deploy.sh -p "$AWS_PROFILE" "$@"
