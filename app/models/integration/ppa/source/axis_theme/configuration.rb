class Integration::PPA::Source::AxisTheme::Configuration < Integration::BaseConfiguration

  #  Validations

  ## Presence

  validates :wsdl,
    :user,
    :password,
    :operation,
    :response_path,
    :schedule,
    presence: true


  # Privates

  private

  def importer_class
    Integration::PPA::Source::AxisTheme::Importer
  end
end
