#!/usr/bin/env bash
# exit on error
set -o errexit

echo "Starting bundle install..."
bundle install
echo "Starting db:setup..."
bundle exec rake db:setup
echo "Starting db:migrate..."
bundle exec rake db:migrate
