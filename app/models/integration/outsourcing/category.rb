class Integration::Outsourcing::Category < ApplicationRecord

  validates :description, presence: true
  validates :description, uniqueness: true


end
