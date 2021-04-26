# syntax=docker/dockerfile:1
FROM ruby:2.6.0
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /api
COPY Gemfile /api/Gemfile
COPY Gemfile.lock /api/Gemfile.lock
RUN gem update --system
RUN gem install bundler:2.1.4
RUN bundle install

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3001"]