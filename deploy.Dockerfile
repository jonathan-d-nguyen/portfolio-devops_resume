# deploy.Dockerfile
FROM alpine:latest

# Install required packages
RUN apk add --no-cache \
    bash \
    aws-cli \
    curl \
    jq \
    python3 \
    py3-pip

# Install Terraform
RUN wget https://releases.hashicorp.com/terraform/1.9.1/terraform_1.9.1_linux_amd64.zip \
    && unzip terraform_1.9.1_linux_amd64.zip \
    && mv terraform /usr/local/bin/ \
    && rm terraform_1.9.1_linux_amd64.zip

# Create non-root user
RUN addgroup -S deployer && adduser -S deployer -G deployer
RUN mkdir -p /home/deployer/.aws

# Set up working directory
WORKDIR /deployment

# Switch to non-root user
USER deployer

ENTRYPOINT ["/bin/bash"]