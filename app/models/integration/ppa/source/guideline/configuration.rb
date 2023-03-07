class Integration::PPA::Source::Guideline::Configuration < Integration::BaseConfiguration

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
    Integration::PPA::Source::Guideline::Importer
  end
end
