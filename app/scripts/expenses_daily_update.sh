#!/usr/bin/env bash

# load rvm ruby
source /usr/local/rvm/environments/ruby-2.5.8@sprc-data

pkill -f 'integration:expenses:daily_update'
cd /app/sprc-data/current && RAILS_ENV=production BYPASS_STATS=true BYPASS_SPREADSHEETS=true bin/rake  integration:expenses:daily_update

pkill -f 'integration:expenses:create_stats_for_current_year'
cd /app/sprc-data/current && RAILS_ENV=production bin/rake integration:expenses:create_stats_for_current_year
