#
# Representa: Planejamento dos Itens de NED
#
#
class Integration::Expenses::NedPlanningItem < ApplicationDataRecord

  # Associations

  belongs_to :ned, foreign_key: 'integration_expenses_ned_id',
    inverse_of: :ned_planning_items


  # Validations

  ## Presence

  validates :ned,
    presence: true

end
