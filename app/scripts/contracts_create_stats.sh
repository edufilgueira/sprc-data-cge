#!/usr/bin/env bash

# load rvm ruby
source /usr/local/rvm/environments/ruby-2.5.8@sprc-data

pkill -f 'integration:contracts:create_stats'

cd /app/sprc-data/current && RAILS_ENV=production nohup bin/rake integration:contracts:create_stats &
