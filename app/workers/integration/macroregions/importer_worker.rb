class Integration::Macroregions::ImporterWorker
  include Sidekiq::Worker

  def perform
    configuration_id = Integration::Macroregions::Configuration.first_or_initialize.id

    Integration::Importers::Import.call(:macroregions, configuration_id)
  end
end
