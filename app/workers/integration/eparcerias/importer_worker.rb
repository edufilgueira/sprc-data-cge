class Integration::Eparcerias::ImporterWorker
  include Sidekiq::Worker

  def perform
    configuration_id = Integration::Eparcerias::Configuration.first_or_initialize.id

    Integration::Importers::Import.call(:eparcerias, configuration_id)
  end
end
