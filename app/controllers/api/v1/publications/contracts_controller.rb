class Api::V1::Publications::ContractsController < Api::V1::Publications::BaseController

  PERMITTED_PARAMS = [
    :data_assinatura,
    :data_processamento,
    :data_publicacao_portal,
    :data_termino,
    :flg_tipo,
    :isn_parte_destino,
    :isn_sic,
    :valor_contrato,
    :isn_modalidade,
    :isn_entidade,
    :valor_can_rstpg,
    :valor_original_concedente,
    :valor_original_contrapartida,
    :valor_atualizado_concedente,
    :valor_atualizado_contrapartida,
    :num_spu,
    :num_contrato,
    :descricao_situacao,
    :descricao_nome_credor,
    :cpf_cnpj_financiador,
    :infringement_status,
    :tipo_objeto,
    :descricao_objeto,
    :descricao_justificativa,
    :cod_gestora,
    :cod_concedente,
    :cod_secretaria,
    :data_publicacao_doe,
    :descricao_url,
    :data_termino_original,
    :data_rescisao,
    :data_inicio,
    :confidential,
  ]
end