#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Forcer la création/mise à jour de la table sessions en production
RAILS_ENV=production bundle exec rails db:migrate