FROM nginx:alpine
LABEL MAINTAINER="Jonathan Nguyen jonathan@jdnguyen.tech"

COPY website-ec /website
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
