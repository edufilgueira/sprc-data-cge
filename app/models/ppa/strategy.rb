module PPA
  class Strategy < ApplicationSprcRecord
    belongs_to :objective
    belongs_to :objective_theme

    has_many :initiative_strategies, dependent: :destroy
    has_many :initiatives, through: :initiative_strategies
    has_many :products, through: :initiatives

    # annual associations
    has_many :annual_regional_strategies, dependent: :destroy, class_name: 'PPA::Annual::RegionalStrategy'
    has_many :annual_regional_initiatives, through: :initiatives
    has_many :annual_regional_products, through: :products

    # biennial associations
    has_many :biennial_regional_strategies, dependent: :destroy, class_name: 'PPA::Biennial::RegionalStrategy'
    has_many :biennial_regional_initiatives, through: :initiatives
    has_many :biennial_regional_products, through: :products


    #validates :code, presence: true, uniqueness: { case_sensitive: false }
    validates :name, presence: true

  end
end
