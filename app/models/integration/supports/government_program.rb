#
# Tabela Execício
#
# Programa de Governo
#

class Integration::Supports::GovernmentProgram < ApplicationDataRecord

  # Validations

  ## Presence

  validates :codigo_programa,
    :titulo,
    presence: true

  # Public

  ## Instance methods

  ### Helpers

  def title
    titulo
  end
end
