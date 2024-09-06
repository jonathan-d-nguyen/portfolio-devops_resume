FROM jenkins/jenkins:alpine-jdk21
LABEL maintainer="Jonathan Nguyen jonathan@jdnguyen.tech"

WORKDIR /var/jenkins_home
RUN git clone https://github.com/PizzaRazi/jenkins.git .

EXPOSE 8080

ENTRYPOINT ["/usr/bin/jenkins"]
