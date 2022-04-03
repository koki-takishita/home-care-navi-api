# syntax=docker/dockerfile:1
FROM ruby:3.1.1
RUN apt-get update -qq && apt-get install -y postgresql-client
WORKDIR /api
COPY Gemfile Gemfile.lock /api/

# Add a script to be executed every time the container starts.
RUN bundle install
RUN rails db:create
RUN rails db:migrate

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
