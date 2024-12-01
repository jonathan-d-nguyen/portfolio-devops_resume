# terraform.Dockerfile
FROM alpine
LABEL MAINTAINER="Jonathan Nguyen jonathan@jdnguyen.tech"

# Create a non-root user with explicit UID/GID
RUN addgroup -S tfgroup -g 1001 && \
    adduser -S tfuser -u 1001 -G tfgroup

# Install required packages including aws-cli
RUN apk add --no-cache \
    aws-cli \
    curl \
    ca-certificates \
    unzip \
    bash

RUN wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/1.9.1/terraform_1.9.1_linux_arm64.zip && \
    unzip /tmp/terraform.zip -d /usr/local/bin/ && \
    rm /tmp/terraform.zip && \
    # Create and set permissions for AWS credentials directory
    mkdir -p /home/tfuser/.aws && \
    chown -R tfuser:tfgroup /home/tfuser/.aws && \
    chmod 700 /home/tfuser/.aws

# Set working directory and ensure proper permissions
WORKDIR /workspace
RUN chown tfuser:tfgroup /workspace

# Switch to non-root user
USER tfuser

# Set default command
ENTRYPOINT ["terraform"]
CMD ["--help"]