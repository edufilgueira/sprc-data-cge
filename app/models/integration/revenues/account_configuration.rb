class Integration::Revenues::AccountConfiguration < ApplicationDataRecord

  # Associations

  belongs_to :configuration, foreign_key: 'integration_revenues_configuration_id'

  # Validations

  ## Presence

  validates :account_number,
    :title,
    :configuration,
    presence: true
end
