source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Core

gem 'rails', '~> 5.0.7'
gem 'puma', '~> 3.0'
gem 'figaro'
gem 'paranoia'

# https://github.com/refile/refile
gem "refile", github: 'refile/refile', require: "refile/rails"
gem "refile-mini_magick", github: 'refile/refile-mini_magick'
# https://github.com/refile/refile/issues/447
gem 'sinatra', github: 'sinatra/sinatra', branch: 'master'

gem 'fcm'

# Database

gem 'bcrypt'
gem 'pg', '0.21.0'

# Background job

gem 'sidekiq', '5.2.8'
gem 'redis', '~>4.1.3'
gem 'whenever'

# SOAP client
# gem 'savon', '~> 2.3.0'

# Para poder usar proxy e testar a integração com os webservices durante o
# desenvolvimento, é preciso a versão 3 do savon (que ainda não é production-ready).
#
# Ver config do proxy em BaseIntegrationsImporter
gem 'savon', github: 'savonrb/savon', branch: 'master'

# serializer
gem 'active_model_serializers', '~> 0.10.0'

# Axlsx: Office Open XML Spreadsheet Generation

#gem 'axlsx', git: 'https://github.com/randym/axlsx', branch: 'master'
#gem 'axlsx_rails', '~> 0.6.0'
#gem 'roo', '~> 2.8.2'
gem 'caxlsx'
gem 'caxlsx_rails'
gem 'roo', '~> 2.8.3'

#Exibir informações organizadas em terminal
gem 'awesome_print'

gem 'haml'


#Analistic
gem 'newrelic_rpm'

group :production do
  #gem 'elastic-apm'
end


group :development, :test do
  gem 'byebug'
  gem 'factory_bot_rails', '4.8.2'
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'timecop'
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :development do

  # deploy
  gem 'airbrussh'
  gem "capistrano", "~> 3.16.0"
  gem 'capistrano-rvm'
  gem 'capistrano-rails'
  gem 'capistrano-passenger'

  gem 'better_errors'
  gem 'binding_of_caller'

  # TODO acompanhar https://github.com/ddollar/foreman/issues/688 e atualizar foreman quando
  # corrigirem e lançarem nova versão (> 0.84.0)
  gem 'foreman', git: 'https://github.com/ppdeassis/foreman.git', branch: 'thor-updated'

  gem 'letter_opener'
  gem 'listen'
  gem 'metric_fu'
  gem 'rails_best_practices'
  gem "rails-erd"
end

group :test do
  gem 'codeclimate-test-reporter'

  gem 'database_cleaner'
  gem 'fake_ftp'
  gem 'guard-rspec'
  gem 'rails-controller-testing'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'spring-commands-rspec'

  gem 'simplecov'
  gem 'simplecov-rcov'

  gem 'terminal-notifier-guard', require: false

  gem 'shoulda-callback-matchers', '~> 1.1.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
