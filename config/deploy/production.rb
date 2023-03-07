set :deploy_to, -> { fetch(:stage_deploy_to, "/app/#{fetch(:application)}") }

# git.cge.ce.gov.br -> 172.24.49.3
#set :repo_url, "git@172.24.49.3:g_sprc/sprc-data.git"

set :default_env, {
  "PASSENGER_INSTANCE_REGISTRY_DIR" => "/var/run/passenger-instreg",
  "LC_ALL" => "pt_BR.UTF-8"
}

set :passenger_rvm_ruby_version, -> { fetch(:stage_passenger_rvm_ruby_version, '2.5.8@sprc-data') }
set :rvm_ruby_version, -> { fetch(:stage_rvm_ruby_version, '2.5.8@sprc-data') }


set :stage_sidekiq_path, 'service sprc-data.sidekiq'

set :whenever_roles, "whenever"

# service-01
server "172.20.4.182", user: "sprc", roles: %w{app db sidekiq whenever}
server "172.20.4.171", user: "sprc", roles: %w{app db sidekiq}