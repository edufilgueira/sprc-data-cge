# Preview all emails at http://localhost:3000/rails/mailers/status_report_mailer
class StatusReportMailerPreview < ActionMailer::Preview

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

	def integrations
    StatusReportMailer.integrations('cttecnico@cge.ce.gov.br', result)
  end

  private 

  def result
  	result = Array.new

    for configuration in CLASS_TO_REPORT
    	configuration_hash = configuration.last.attributes.slice('status', 
    		'last_importation', 
    		'updated_at')

    	result << { "class": configuration.name }.merge(configuration_hash)
    end
    result
  end
end
