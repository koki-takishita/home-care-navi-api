# syntax=docker/dockerfile:1
FROM ruby:3.1.1
RUN apt-get update -qq && apt-get install -y postgresql-client
WORKDIR /api
COPY Gemfile Gemfile.lock /api/
RUN bundle install
RUN rails db:create
RUN rails db:migrate
