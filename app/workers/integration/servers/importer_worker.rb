class Integration::Servers::ImporterWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'servers_import'

  def perform
    configuration_id = Integration::Servers::Configuration.first_or_initialize.id

    Integration::Importers::Import.call(:servers, configuration_id)
  end
end
