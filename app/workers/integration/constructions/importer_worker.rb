class Integration::Constructions::ImporterWorker
  include Sidekiq::Worker

  def perform
    configuration_id = Integration::Constructions::Configuration.first_or_initialize.id

    Integration::Importers::Import.call(:constructions, configuration_id)
  end
end
