class Integration::Supports::Organ::Configuration < Integration::BaseConfiguration

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
    Integration::Supports::Organ::Importer
  end
end
