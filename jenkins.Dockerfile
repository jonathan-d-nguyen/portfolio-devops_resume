FROM jenkins/jenkins:alpine-jdk21
LABEL maintainer="Jonathan Nguyen jonathan@jdnguyen.tech"

COPY jenkins_plugins.txt /usr/share/jenkins/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/plugins.txt
EXPOSE 8080

# RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt
# WORKDIR /var/jenkins_home
# ENTRYPOINT ["/usr/bin/jenkins"]
