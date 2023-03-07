class Integration::Supports::Domain::Configuration < Integration::BaseConfiguration

  #  Validations

  ## Presence

  validates :wsdl,
    :user,
    :password,
    :operation,
    :response_path,
    :schedule,
    :year,
    presence: true


  # Privates

  private

  def importer_class
    Integration::Supports::Domain::Importer
  end
end
