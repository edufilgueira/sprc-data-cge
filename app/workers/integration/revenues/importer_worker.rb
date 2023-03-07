class Integration::Revenues::ImporterWorker
  include Sidekiq::Worker

  def perform
    configuration = Integration::Revenues::Configuration.first_or_initialize

    configuration.update(month: "#{Date.today.month}/#{Date.today.year}")

    Integration::Importers::Import.call(:revenues, configuration.id)
  end
end
