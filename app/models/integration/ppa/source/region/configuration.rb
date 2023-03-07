class Integration::PPA::Source::Region::Configuration < Integration::BaseConfiguration

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
    Integration::PPA::Source::Region::Importer
  end
end
