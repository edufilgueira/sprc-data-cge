#
# This class exists to avoid a has_and_belongs_to_many
# between objectives and themes as data comes from external
# API and some info may extend increment its attributes.
#
class PPA::ObjectiveTheme < ApplicationSprcRecord

  belongs_to :objective
  belongs_to :theme
  belongs_to :region

  has_many :strategies, dependent: :destroy

  validates :objective, presence: true
  validates :theme, presence: true
  validates :region, presence: true

  # uniqueness
  validates :theme_id, uniqueness: { scope: [:objective_id, :region_id ]}

end
