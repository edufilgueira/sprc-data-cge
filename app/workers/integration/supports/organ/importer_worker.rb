class Integration::Supports::Organ::ImporterWorker
  include Sidekiq::Worker

  def perform
    configuration_id = Integration::Supports::Organ::Configuration.first_or_initialize.id

    Integration::Importers::Import.call(:supports_organ, configuration_id)
  end
end
