FROM ruby:2.5.5
RUN apt-get update && apt-get -y install git procps
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
COPY Gemfile* ./
RUN bundle
RUN bundle exec yard gems
ENV SHELL /bin/bash
