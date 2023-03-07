sidekiq_yml = YAML::load_file(Rails.root.join('config', 'sidekiq.yml'))
redis_url = sidekiq_yml.fetch(:redis_url, 'redis://localhost:6379')

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end

# Habilitando o sidekiq para métodos de classe
Sidekiq::Extensions.enable_delay!
