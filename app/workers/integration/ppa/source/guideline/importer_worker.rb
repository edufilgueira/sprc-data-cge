class Integration::PPA::Source::Guideline::ImporterWorker
  include Sidekiq::Worker

  def perform
    configuration_id = Integration::PPA::Source::Guideline::Configuration.first_or_initialize.id

    Integration::Importers::Import.call(:ppa_source_guideline, configuration_id)
  end
end
