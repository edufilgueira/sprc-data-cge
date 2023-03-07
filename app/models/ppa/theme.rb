module PPA
  class Theme < ApplicationSprcRecord

    belongs_to :axis

    has_many :theme_strategies
    has_many :strategies, through: :theme_strategies

    validates :axis, presence: true
    validates :code, presence: true, uniqueness: { scope: :axis_id }
    validates :name, presence: true

    delegate :name, to: :axis, prefix: true

    def strategies
      PPA::Strategy.joins(:objective_theme).where(ppa_objective_themes: { theme_id: id} )
    end
  end
end
