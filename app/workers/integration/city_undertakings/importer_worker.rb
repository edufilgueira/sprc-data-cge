class Integration::CityUndertakings::ImporterWorker
  include Sidekiq::Worker

  def perform
    configuration_id = Integration::CityUndertakings::Configuration.first_or_initialize.id

    Integration::Importers::Import.call(:city_undertakings, configuration_id)
  end
end
