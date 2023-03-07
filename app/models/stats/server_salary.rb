class Stats::ServerSalary < ApplicationDataRecord

  # Validations

  ## Presence

  validates :month,
    :year,
    presence: true

  ## Uniqueness

  validates_uniqueness_of :month,
    scope: [:year]

  # Serializations

  serialize :data, Hash

end
