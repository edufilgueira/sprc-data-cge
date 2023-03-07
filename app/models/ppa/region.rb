module PPA
  class Region < ApplicationSprcRecord

    has_many :cities, class_name: 'PPA::City', foreign_key: :ppa_region_id, dependent: :nullify
    # XXX ordered_cities apenas para usar em simple_form grouped selects
    has_many :ordered_cities, -> { order(:name) }, class_name: 'PPA::City', foreign_key: :ppa_region_id

    has_many :annual_regional_strategies, class_name: 'PPA::Annual::RegionalStrategy',
             dependent: :destroy
    has_many :strategies, -> { distinct }, through: :annual_regional_strategies
    has_many :objectives, through: :strategies
    has_many :votings
    has_many :proposal_themes

    validates :code, :name, presence: true, uniqueness: { case_sensitive: false }

  end
end
