#!/bin/bash
# scripts/test.sh

set -e

# 1. Spin up staging environment
docker-compose -f docker-compose.test.yml run --rm terraform terraform init
docker-compose -f docker-compose.test.yml run --rm terraform terraform apply -auto-approve

# 2. Wait for CloudFront distribution to deploy
echo "Waiting for CloudFront distribution to deploy..."
sleep 300  # Adjust time based on your needs

# 3. Run integration tests
docker-compose -f docker-compose.test.yml run --rm integration-tests

# 4. Clean up if tests pass
if [ $? -eq 0 ]; then
    docker-compose -f docker-compose.test.yml run --rm terraform terraform destroy -auto-approve
    exit 0
else
    echo "Tests failed! Staging environment left up for inspection."
    exit 1
fi
