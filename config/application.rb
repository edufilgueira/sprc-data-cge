require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SprcData
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework :rspec
      g.template_engine :haml
    end

    custom_paths = [
      Rails.root.join('app', 'workers'),
      Rails.root.join('app', 'services')
    ]

    # This is needed to make it work in production
    # see http://blog.arkency.com/2014/11/dont-forget-about-eager-load-when-extending-autoload/
    config.eager_load_paths += custom_paths
    config.autoload_paths += custom_paths

    config.active_record.default_timezone = :local
    config.encoding = 'utf-8'
    config.i18n.default_locale = 'pt-BR'
    config.time_zone = 'America/Fortaleza'

    config.generators.assets = false
    config.generators.helper = false

    # carrega os locales separados em vários arquivos

    config.i18n.load_path += Dir[
      Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s
    ]

    config.active_job.queue_adapter = :sidekiq

    # para url_helpers dos serializers e mailers, definido em
    # config/application.yml
    Rails.application.routes.default_url_options[:host] = ENV['DEFAULT_HOST']

  end
end
