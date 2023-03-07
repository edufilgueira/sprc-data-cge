class Integration::Macroregions::Power < ApplicationRecord

  # Validations

  validates :name,
    :code,
    presence: true

  validates :name,
    :code,
    uniqueness: { case_sensitive: false }
end
