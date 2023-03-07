#!/usr/bin/env bash

# load rvm ruby
source /usr/local/rvm/environments/ruby-2.5.8@sprc-data

pkill -f 'integration:eparcerias:daily_update'
cd /app/sprc-data/current && RAILS_ENV=production BYPASS_STATS=true BYPASS_SPREADSHEETS=true bin/rake  integration:eparcerias:daily_update
