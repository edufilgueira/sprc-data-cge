# Worker que envia situação do status 
# dos importadores para a equipe de desenvolvimento

class Integration::StatusReportWorker
  include Sidekiq::Worker

  sidekiq_options

  CLASS_TO_REPORT = [
  	Integration::CityUndertakings::Configuration,
  	Integration::Constructions::Configuration,
  	Integration::Contracts::Configuration,
  	Integration::Eparcerias::Configuration,
  	Integration::Expenses::Configuration,
  	Integration::Macroregions::Configuration,
  	Integration::Outsourcing::MonthlyCosts::Configuration,
  	Integration::PPA::Source::AxisTheme::Configuration,
  	Integration::PPA::Source::AxisThemeObjectiveStrategy::Configuration,
  	Integration::PPA::Source::Guideline::Configuration,
  	Integration::PPA::Source::Region::Configuration,
  	Integration::Purchases::Configuration,
  	Integration::RealStates::Configuration,
  	Integration::Results::Configuration,
  	Integration::Revenues::AccountConfiguration,
  	Integration::Revenues::Configuration,
  	Integration::Servers::Configuration,
  	Integration::Supports::Axis::Configuration,
  	Integration::Supports::Creditor::Configuration,
  	Integration::Supports::Domain::Configuration,
  	Integration::Supports::Organ::Configuration,
  	Integration::Supports::Theme::Configuration,
  ]

  RECIPIENTS = [
    'cttecnico@cge.ce.gov.br',
    'matheus.borges@cge.ce.gov.br',
  ]

  def perform
  	# Percorrer classes
  	# Consultar e iterar configurations 
  	# Preparar array e enviar p mailer
    result = Array.new

    for configuration in CLASS_TO_REPORT
    	configuration_hash = configuration.last.attributes.slice('status', 
    		'last_importation', 
    		'updated_at')

    	result << { "class": configuration.name }.merge(configuration_hash)
    end     
    
    recipients.each do |recipient|
      StatusReportMailer.integrations(recipient, result).deliver
    end    
  end

  def recipients
    RECIPIENTS
  end
end
