module PPA
  class Objective < ApplicationSprcRecord

    has_many :themes, through: :objective_themes

    validates :code, presence: true, uniqueness: { case_sensitive: false }
    validates :name, presence: true
  end
end
