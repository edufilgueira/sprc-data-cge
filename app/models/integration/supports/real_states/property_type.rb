class Integration::Supports::RealStates::PropertyType < ApplicationDataRecord

  validates :title, presence: true, uniqueness: { case_sensitive: false }

end
