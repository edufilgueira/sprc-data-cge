class Integration::Contracts::ImporterWorker
  include Sidekiq::Worker

  def perform
    configuration = Integration::Contracts::Configuration.first_or_initialize

    #
    # atualizando automaticamente para importações automáticas do whenever/crontab
    #
    last_data_assinatura = Integration::Contracts::Contract.unscoped.order(data_assinatura: :desc).first&.data_assinatura || Date.yesterday
    configuration.update(start_at: last_data_assinatura, end_at: Date.today)

    Integration::Importers::Import.call(:contracts, configuration.id)
  end
end
