class Integration::Supports::Creditor < ApplicationDataRecord
  include ::Integration::Supports::Creditor::Search
  include ::Sortable

  # Validations

  ## Presence

  validates :nome,
    :codigo,
    presence: true
    

  ## Uniqueness

  validates :codigo,
    uniqueness: true

  # Public

  ## Class methods

  ### Scopes

  def self.default_sort_column
    'integration_supports_creditors.nome'
  end

  def self.default_sort_direction
    :asc
  end

  ## Instance methods

  ### Helpers

  def title
    nome
  end
end
