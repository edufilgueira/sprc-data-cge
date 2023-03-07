class Integration::Contracts::Situation < ApplicationDataRecord

	validates :description, 	presence: true
	validates :description, uniqueness: true

	def title
   	description
  end

end
