class Integration::Outsourcing::Consolidation < ApplicationRecord

  validates :mes,
    :qde_terc_alocados,
    :vlr_custo,
    :vlr_remuneracao,
    :vlr_encargos_taxas,
    :month,
    :year,
    presence: true



end
