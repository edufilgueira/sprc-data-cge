class Integration::Macroregions::Configuration < Integration::BaseConfiguration

  #  Validations

  ## Presence

  validates :wsdl,
    :user,
    :password,
    :operation,
    :year,
    :response_path,
    :operation,
    :schedule,
    presence: true

  # Instace methods

  ## Helpers

  def importer_class
    Integration::Macroregions::Importer
  end
end
