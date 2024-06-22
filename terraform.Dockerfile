FROM alpine
LABEL MAINTAINER="Jonathan Nguyen jonathan@jdnguyen.tech"

# RUN wget https://releases.hashicorp.com/terraform/1.8.5/terraform_1.8.5_linux_amd64.zip
# RUN unzip terraform_1.8.5_linux_amd64.zip && rm terraform_1.8.5_linux_amd64.zip
# RUN mv terraform ~/bin/              # Move to your user's bin directory
# RUN wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/1.8.5/terraform_1.8.5_linux_amd64.zip
# RUN unzip /tmp/terraform.zip -d ~/bin/
#  && rm /tmp/terraform.zip


# # RUN wget -O terraform.zip https://releases.hashicorp.com/terraform/1.8.5/terraform_1.8.5_linux_amd64.zip
# # RUN unzip -o terraform.zip terraform
# # RUN rm terraform.zip
# # RUN cp terraform /usr/local/bin/
# 
# 
RUN wget https://releases.hashicorp.com/terraform/1.8.5/terraform_1.8.5_linux_amd64.zip
RUN unzip terraform_1.8.5_linux_amd64.zip
# RUN mv terraform ~/bin/
# RUN rm terraform_1.8.5_linux_amd64.zip

USER nobody