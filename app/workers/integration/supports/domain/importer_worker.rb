class Integration::Supports::Domain::ImporterWorker
  include Sidekiq::Worker

  def perform
    configuration = Integration::Supports::Domain::Configuration.first_or_initialize

    #
    # atualizando automaticamente para importações automáticas do whenever/crontab
    #
    configuration.update(year: Date.today.year)

    Integration::Importers::Import.call(:supports_domain, configuration.id)
  end
end
