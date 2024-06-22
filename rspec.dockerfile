FROM ruby:alpine
MAINTAINER Carlos Nunez <dev@carlosnunez.me>

RUN apk add --no-cache build-base ruby-nokogiri
RUN gem install rspec capybara selenium-webdriver
ENTRYPOINT [ "rspec" ]
