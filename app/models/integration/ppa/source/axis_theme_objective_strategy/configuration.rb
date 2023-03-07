class Integration::PPA::Source::AxisThemeObjectiveStrategy::Configuration < Integration::BaseConfiguration

  #  Validations

  ## Presence

  validates :wsdl,
    :user,
    :password,
    :year,
    :operation,
    :response_path,
    :schedule,
    presence: true


  # Privates

  private

  def importer_class
    Integration::PPA::Source::AxisThemeObjectiveStrategy::Importer
  end
end
