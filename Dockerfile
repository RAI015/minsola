FROM ruby:2.6.5-alpine

# RUN apt-get update -qq && \
#     apt-get install -y build-essential \
#                        libpq-dev \
#                        nodejs

RUN apk add git --no-cache
RUN apk add --update bash perl --no-cache
RUN apk add libxslt-dev libxml2-dev build-base --no-cache
RUN apk add mysql-client mysql-dev --no-cache
RUN apk add --no-cache file
RUN apk add yarn --no-cache
RUN apk add tzdata --no-cache
RUN apk --update add imagemagick --no-cache

RUN mkdir /app_name
ENV APP_ROOT /app_name
WORKDIR $APP_ROOT

COPY ./Gemfile $APP_ROOT/Gemfile
COPY ./Gemfile.lock $APP_ROOT/Gemfile.lock

RUN gem install bundler
RUN bundle install
COPY . $APP_ROOT