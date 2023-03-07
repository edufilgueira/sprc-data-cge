class PPA::Source::Region < ApplicationRecord

  # Validations

  validates :codigo_regiao,    presence: true, uniqueness: true
  validates :descricao_regiao, presence: true, uniqueness: true

end
