class Integration::Supports::Theme::ImporterWorker
  include Sidekiq::Worker

  def perform
    configuration_id = Integration::Supports::Theme::Configuration.first_or_initialize.id

    Integration::Importers::Import.call(:supports_theme, configuration_id)
  end
end
