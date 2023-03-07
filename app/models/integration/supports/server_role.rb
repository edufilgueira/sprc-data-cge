class Integration::Supports::ServerRole < ApplicationDataRecord

  # Associations

  has_many :server_salaries, foreign_key: 'integration_supports_server_role_id', class_name: 'Integration::Servers::ServerSalary'

  # Validations

  ## Presence

  validates :name,
    presence: true

  def title
    name
  end
end
