#
# Representa: Previsões de Desembolso de NED
#
#
class Integration::Expenses::NedDisbursementForecast < ApplicationDataRecord

  # Associations

  belongs_to :ned, foreign_key: 'integration_expenses_ned_id',
    inverse_of: :ned_disbursement_forecasts


  # Validations

  ## Presence

  validates :ned,
    presence: true
end
