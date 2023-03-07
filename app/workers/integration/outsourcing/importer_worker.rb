class Integration::Outsourcing::ImporterWorker
  include Sidekiq::Worker

  def perform
  	configuration = Integration::Outsourcing::MonthlyCosts::Configuration.first
    month_year = Date.today.strftime("%m/%Y")
    configuration.update(month: month_year)

    Integration::Importers::Import.call(:outsourcing_monthly_costs, configuration.id)
  end
end
