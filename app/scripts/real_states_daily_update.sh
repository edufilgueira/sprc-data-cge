#!/usr/bin/env bash

# load rvm ruby
source /usr/local/rvm/environments/ruby-2.5.8@sprc-data

pkill -f 'Integration::RealStates::ImporterWorker.perform_async'
cd /app/sprc-data/current && RAILS_ENV=production bin/rails runner 'Integration::RealStates::ImporterWorker.perform_async' >> /app/sprc-data/current/log/cron.log 2>&1
