require 'rails_helper'
require 'integration/contracts/convenant/spreadsheet_presenter.rb'

describe Integration::Contracts::Convenant::SpreadsheetPresenter do

  subject(:spreadsheet_presenter) do
    Integration::Contracts::Convenant::SpreadsheetPresenter.new(convenant)
  end

  let(:convenant) { create(:integration_contracts_convenant) }

  let(:klass) { Integration::Contracts::Convenant }

  let(:columns) do
    [
      :data_assinatura,
      :data_termino_original,
      :data_termino,
      :data_rescisao,
      :data_publicacao_portal,
      :isn_sic,
      :num_contrato,
      :cod_plano_trabalho,
      :cpf_cnpj_financiador,
      :status_str,
      :accountability_status,
      :manager_title,
      :grantor_title,
      :creditor_title,
      :descriaco_edital,
      :descricao_situacao,
      :decricao_modalidade,
      :tipo_objeto,
      :descricao_objeto,
      :descricao_justificativa,
      :valor_contrato,
      :valor_can_rstpg,
      :valor_original_concedente,
      :valor_original_contrapartida,
      :valor_atualizado_contrapartida,
      :valor_atualizado_concedente,
      :valor_atualizado_total,
      :calculated_valor_empenhado,
      :calculated_valor_pago
    ]
  end

  it 'spreadsheet_header' do
    expected = columns.map{|column| klass.human_attribute_name(column)}

    expect(Integration::Contracts::Convenant::SpreadsheetPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    data_assinatura = I18n.l(convenant.data_assinatura.to_date)
    data_processamento = I18n.l(convenant.data_processamento.to_date)
    data_termino = I18n.l(convenant.data_termino.to_date)
    data_publicacao_portal = I18n.l(convenant.data_publicacao_portal.to_date)

    manager_title = convenant.manager_title || convenant.cod_gestora
    grantor_title = convenant.grantor_title || convenant.cod_concedente
    creditor_title = convenant.descricao_nome_credor

    expected = [
      data_assinatura,
      convenant.send(:data_termino_original),
      data_termino,
      convenant.send(:data_rescisao),
      data_publicacao_portal,
      convenant.isn_sic,
      convenant.num_contrato,
      convenant.cod_plano_trabalho,
      convenant.cpf_cnpj_financiador,
      convenant.status_str,
      convenant.accountability_status,
      manager_title,
      grantor_title,
      creditor_title,
      convenant.descriaco_edital,
      convenant.descricao_situacao,
      convenant.decricao_modalidade,
      convenant.tipo_objeto,
      convenant.descricao_objeto,
      convenant.descricao_justificativa,
      convenant.valor_contrato,
      convenant.valor_can_rstpg,
      convenant.valor_original_concedente,
      convenant.valor_original_contrapartida,
      convenant.valor_atualizado_contrapartida,
      convenant.valor_atualizado_concedente,
      convenant.valor_atualizado_total,
      convenant.calculated_valor_empenhado,
      convenant.calculated_valor_pago
    ]

    result = spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
