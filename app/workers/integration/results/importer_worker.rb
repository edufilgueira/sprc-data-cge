class Integration::Results::ImporterWorker
  include Sidekiq::Worker

  def perform
    configuration_id = Integration::Results::Configuration.first_or_initialize.id

    Integration::Importers::Import.call(:results, configuration_id)
  end
end
