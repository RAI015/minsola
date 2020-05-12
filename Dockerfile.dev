FROM ruby:2.6.5-alpine

ENV RUNTIME_PACKAGES="bash file gcc g++ imagemagick libc-dev linux-headers libxml2-dev libxslt-dev make mysql-client mysql-dev nodejs tzdata vim yarn" \
    BUILD_PACKAGES="build-base curl-dev" \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo

# RSpec Systemテスト用
RUN apk add -U --no-cache chromium chromium-chromedriver
RUN mkdir /noto
ADD https://noto-website.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip /noto
WORKDIR /noto
RUN unzip NotoSansCJKjp-hinted.zip && \
    mkdir -p /usr/share/fonts/noto && \
    cp *.otf /usr/share/fonts/noto && \
    chmod 644 -R /usr/share/fonts/noto/ && \
    fc-cache -fv

RUN mkdir /minsola
ENV APP_ROOT /minsola
WORKDIR $APP_ROOT

COPY ./Gemfile $APP_ROOT/Gemfile
COPY ./Gemfile.lock $APP_ROOT/Gemfile.lock

RUN apk update && \
    apk upgrade && \
    apk add --no-cache ${RUNTIME_PACKAGES} && \
    apk add --virtual build-packages --no-cache ${BUILD_PACKAGES} && \
    gem install bundler && \
    bundle install && \
    apk del build-packages

COPY . $APP_ROOT