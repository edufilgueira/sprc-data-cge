class Integration::RealStates::ImporterWorker
  include Sidekiq::Worker

  def perform
    configuration_id = Integration::RealStates::Configuration.first_or_initialize.id

    Integration::Importers::Import.call(:real_states, configuration_id)
  end
end
