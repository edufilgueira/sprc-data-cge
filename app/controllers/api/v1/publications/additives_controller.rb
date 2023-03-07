class Api::V1::Publications::AdditivesController < Api::V1::Publications::BaseController

  PERMITTED_PARAMS = [
    :data_aditivo,
    :data_inicio,
    :data_publicacao,
    :data_termino,
    :flg_tipo_aditivo,
    :isn_contrato_aditivo,
    :isn_ig,
    :isn_sic,
    :valor_acrescimo,
    :valor_reducao,
    :data_publicacao_portal,
    :descricao_url,
    :descricao_tipo_aditivo,
    :descricao_observacao,
  ]

  def finder_column
    :isn_contrato_aditivo
  end
end
