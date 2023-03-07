#!/usr/bin/env bash

# load rvm ruby
source /usr/local/rvm/environments/ruby-2.5.8@sprc-data

pkill -f 'integration:contracts:daily_update'
cd /app/sprc-data/current && RAILS_ENV=production nohup bin/rake integration:contracts:daily_update &
