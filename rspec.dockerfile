FROM ruby:alpine
LABEL MAINTAINER="Jonathan Nguyen jonathan@jdnguyen.tech"

RUN apk add --no-cache build-base ruby-nokogiri gcompat
RUN gem install rspec capybara selenium-webdriver
ENTRYPOINT [ "rspec" ]
