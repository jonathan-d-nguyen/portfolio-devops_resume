FROM alpine
LABEL MAINTAINER="Jonathan Nguyen jonathan@jdnguyen.tech"
RUN wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/1.9.1/terraform_1.9.1_linux_arm64.zip
RUN unzip /tmp/terraform.zip -d /
RUN apk add --no-cache ca-certificates curl
USER nobody
ENTRYPOINT [ "/terraform" ]