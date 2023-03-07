#
# Planos plurianuais
#
module PPA
  class Plan < ApplicationSprcRecord

    enum status: {
      elaborating: 0,
      monitoring: 1,
      evaluating: 2,
      revising: 3
    }

    DURATION = 4 # in years

    has_many :workshops
    has_many :proposals, dependent: :destroy
    has_many :proposal_themes
    has_many :votings
    has_many :axes
    has_many :themes, through: :axes
    has_many :objective_themes, through: :themes
    has_many :strategies, through: :objective_themes

    # Scopes

    scope :sorted, -> { order(end_year: :desc) }

    before_create do
      raise 'Can not create this record. Please user SPRC/Models/PPA/Plan'
    end
  end
end
