set :deploy_to, -> { fetch(:stage_deploy_to, "/app/#{fetch(:application)}") }
set :repo_url, "git@git.cge.local:g_sprc/sprc-data.git"

set :passenger_rvm_ruby_version, -> { fetch(:stage_passenger_rvm_ruby_version, '2.5.8@sprc-data') }
set :rvm_ruby_version, -> { fetch(:stage_rvm_ruby_version, '2.5.8@sprc-data') }

set :whenever_roles, nil

server "192.168.3.65", user: "sprc", roles: %w{app db web sidekiq}

set :stage_sidekiq_path, 'service sprc-data.sidekiq'
