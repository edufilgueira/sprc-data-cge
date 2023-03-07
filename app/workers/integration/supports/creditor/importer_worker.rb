class Integration::Supports::Creditor::ImporterWorker
  include Sidekiq::Worker

  def perform
    configuration = Integration::Supports::Creditor::Configuration.first_or_initialize

    configuration.update started_at: last_updated, finished_at: Date.today

    Integration::Importers::Import.call(:supports_creditor, configuration.id)
  end

  private

  def last_updated
    Integration::Supports::Creditor.order(:updated_at).last.updated_at
  end
end
