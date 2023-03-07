class Integration::Purchases::ImporterWorker
  include Sidekiq::Worker

  def perform
    configuration_id = Integration::Purchases::Configuration.first_or_initialize.id

    Integration::Importers::Import.call(:purchases, configuration_id)
  end
end
