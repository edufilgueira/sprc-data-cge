class Integration::Supports::Axis::ImporterWorker
  include Sidekiq::Worker

  def perform
    configuration_id = Integration::Supports::Axis::Configuration.first_or_initialize.id

    Integration::Importers::Import.call(:supports_axis, configuration_id)
  end
end
