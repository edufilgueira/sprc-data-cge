#
# Representa: Itens de NED
#
#
class Integration::Expenses::NedItem < ApplicationDataRecord

  # Associations

  belongs_to :ned, foreign_key: 'integration_expenses_ned_id',
    inverse_of: :ned_items


  # Validations

  ## Presence

  validates :ned,
    presence: true
end
