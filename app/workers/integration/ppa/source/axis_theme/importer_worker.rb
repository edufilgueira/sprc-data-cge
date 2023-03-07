module Integration::PPA::Source
  class AxisTheme::ImporterWorker
    include Sidekiq::Worker

    def perform
      configuration_id = Integration::PPA::Source::AxisTheme::Configuration.first_or_initialize.id

      Integration::Importers::Import.call(:ppa_source_axis_theme, configuration_id)
    end
  end
end
