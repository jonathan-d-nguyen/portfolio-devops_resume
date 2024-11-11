#!/bin/bash
# scripts/test.sh

set -e

# Debug: Show working directory and its contents using shell
docker-compose -f docker-compose.test.yml run --rm --entrypoint=/bin/sh terraform -c "pwd && ls -la"

# Terraform commands (using terraform binary)
docker-compose -f docker-compose.test.yml run --rm --entrypoint=/usr/local/bin/terraform terraform init
docker-compose -f docker-compose.test.yml run --rm --entrypoint=/usr/local/bin/terraform terraform apply -auto-approve

# 2. Wait for CloudFront distribution to deploy
echo "Waiting for CloudFront distribution to deploy..."
sleep 300  # Adjust time based on your needs

# 3. Run integration tests
docker-compose -f docker-compose.test.yml run --rm integration-tests

# 4. Clean up if tests pass
if [ $? -eq 0 ]; then
    docker-compose -f docker-compose.test.yml run --rm --entrypoint=/usr/local/bin/terraform terraform destroy -auto-approve
    exit 0
else
    echo "Tests failed! Staging environment left up for inspection."
    exit 1
fi

# After terraform apply succeeds, deploy the website
aws s3 sync build/ s3://staging.jdnguyen.tech

# Continue with your existing test script...
