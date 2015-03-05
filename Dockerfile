FROM debian:jessie
MAINTAINER Seigo Uchida <spesnova@gmail.com> (@spesnova)

WORKDIR /capistrano

RUN apt-get update && \
    apt-get install ruby -y && \
    rm -rf /var/lib/apt/lists/* && \
    gem install bundler --no-ri --no-rdoc

ADD capistrano/Gemfile      /capistrano/Gemfile
ADD capistrano/Gemfile.lock /capistrano/Gemfile.lock

RUN bundle install

ADD capistrano /capistrano
