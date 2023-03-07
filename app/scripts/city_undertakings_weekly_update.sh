#!/usr/bin/env bash

# load rvm ruby
source /usr/local/rvm/environments/ruby-2.5.8@sprc-data

pkill -f 'integration:city_undertakings:import'
cd /app/sprc-data/current && RAILS_ENV=production bin/rake integration:city_undertakings:import
