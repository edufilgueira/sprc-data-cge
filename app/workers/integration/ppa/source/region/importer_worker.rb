class Integration::PPA::Source::Region::ImporterWorker
  include Sidekiq::Worker

  def perform
    configuration_id = Integration::PPA::Source::Region::Configuration.first_or_initialize.id

    Integration::Importers::Import.call(:ppa_source_region, configuration_id)
  end
end
