#!/usr/bin/env bash
# exit on error
set -o errexit

echo "Starting bundle install..."
bundle install

echo "Starting db:migrate..."
bundle exec rake db:migrate
