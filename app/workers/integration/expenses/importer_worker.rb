class Integration::Expenses::ImporterWorker
  include Sidekiq::Worker

  def perform
    configuration_id = Integration::Expenses::Configuration.first_or_initialize.id

    Integration::Importers::Import.call(:expenses, configuration_id)
  end
end
