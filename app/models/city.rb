class City < ApplicationSprcRecord

  # Setup

  # Associations

  belongs_to :state

  # Delegations

  delegate :acronym, to: :state, prefix: true


  #  Validations

  ## Presence

  validates :code,
    :name,
    :state,
    presence: true

  ## Uniqueness

  validates :code,
    uniqueness: true

  # Scopes

  def self.sorted
    order(:name)
  end

  # Instace methods

  ## Helpers

  def title
    "#{name}/#{state_acronym}"
  end
end
