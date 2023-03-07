class Integration::Outsourcing::MonthlyCosts::Configuration < Integration::BaseConfiguration

  #  Validations

  ## Presence

  validates  :wsdl,
    :user,
    :password,
    :entity_operation,
    :entity_response_path,
    :monthly_cost_operation,
    :monthly_cost_response_path,
    :schedule,
    presence: true


  # Privates

  def month_import
    month.split('/').first
  end

  def year_import
    month.split('/').last
  end

  private

  def importer_class
    Integration::Outsourcing::Importer
  end
end
