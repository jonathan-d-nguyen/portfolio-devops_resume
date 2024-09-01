FROM alpine
LABEL MAINTAINER="Jonathan Nguyen jonathan@jdnguyen.tech"
RUN wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/1.9.1/terraform_1.9.1_linux_arm64.zip
    # -O to name it something convenient
RUN unzip /tmp/terraform.zip -d /
    # this unzips and places a single file, terraform, at root
RUN apk add --no-cache ca-certificates curl
USER nobody
    # mitigtes security issues
ENTRYPOINT [ "/terraform" ]
    # this tells Docker when running a container based on this image, the default command will be /terraform
    # this assumes that a binary, terraform, exists at /
    # use terraform on startup