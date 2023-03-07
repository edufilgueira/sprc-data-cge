module PPA
  class Axis < ApplicationSprcRecord

    belongs_to :plan
    has_many :themes, dependent: :destroy

    validates :name, presence: true
    validates :code, presence: true, uniqueness: { scope: :plan_id }


  end
end
