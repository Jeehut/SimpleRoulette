#!/bin/sh
bundle install
bundle exec jazzy \
  --clean \
  --author fummicc1 \
  --author_url https://fummicc1.dev \
  --module SimpleRoulette \
  --output docs/SimpleRoulette
