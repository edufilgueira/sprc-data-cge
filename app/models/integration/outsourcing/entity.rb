class Integration::Outsourcing::Entity < ApplicationRecord

  validates :dsc_sigla, :isn_entidade, presence: true
  validates :dsc_sigla, :isn_entidade, uniqueness: true

end
