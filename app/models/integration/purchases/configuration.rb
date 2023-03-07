class Integration::Purchases::Configuration < Integration::BaseConfiguration

  #  Validations

  ## Presence

  validates :wsdl,
    :user,
    :password,
    :operation,
    :response_path,
    :schedule,
    presence: true

  # Instace methods

  ## Helpers

  def importer_class
    Integration::Purchases::Importer
  end
end
