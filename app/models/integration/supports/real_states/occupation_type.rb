class Integration::Supports::RealStates::OccupationType < ApplicationDataRecord

  validates :title, presence: true, uniqueness: { case_sensitive: false }

end
