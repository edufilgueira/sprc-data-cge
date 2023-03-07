class PPA::ThemeStrategy < ApplicationSprcRecord

  belongs_to :theme
  belongs_to :strategy

  validates :strategy, presence: true
  validates :theme, presence: true

end
