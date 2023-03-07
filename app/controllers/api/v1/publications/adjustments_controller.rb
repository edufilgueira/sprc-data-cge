class Api::V1::Publications::AdjustmentsController < Api::V1::Publications::BaseController

  PERMITTED_PARAMS = [
    :data_ajuste,
    :data_alteracao,
    :data_exclusao,
    :data_inclusao,
    :data_inicio,
    :data_termino,
    :flg_acrescimo_reducao,
    :flg_controle_transmissao,
    :flg_receita_despesa,
    :flg_tipo_ajuste,
    :isn_contrato_ajuste,
    :isn_contrato_tipo_ajuste,
    :ins_edital,
    :isn_sic,
    :isn_situacao,
    :isn_usuario_alteracao,
    :isn_usuario_aprovacao,
    :isn_usuario_auditoria,
    :isn_usuario_exclusao,
    :valor_ajuste_destino,
    :valor_ajuste_origem,
    :valor_inicio_destino,
    :valor_inicio_origem,
    :valor_termino_origem,
    :valor_termino_destino,
    :descricao_tipo_ajuste,
    :descricao_observacao,
    :descricao_url,
  ]

  def finder_column
    :isn_contrato_ajuste
  end

end
