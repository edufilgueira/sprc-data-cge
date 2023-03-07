class Integration::Contracts::Infringement < ApplicationDataRecord
  include Integration::Contracts::SubResource

  # Validations

  ## Presence

  validates :data_lancamento,
    :data_processamento,
    :data_termino_atual,
    :data_ultima_pcontas,
    :data_ultima_pagto,
    :isn_sic,
    :qtd_pagtos,
    :valor_atualizado_total,
    :valor_inadimplencia,
    :valor_liberacoes,
    :valor_pcontas_acomprovar,
    :valor_pcontas_apresentada,
    :valor_pcontas_aprovada,
    presence: true

  # Public

  ## Instance methods

  ### Helpers

  def title
    cod_financiador
  end
end
