require 'rails_helper'

describe ::Integration::Contracts::Contract::SpreadsheetPresenter do
  subject(:spreadsheet_presenter) do
    ::Integration::Contracts::Contract::SpreadsheetPresenter.new(contract)
  end

  let(:contract) { create(:integration_contracts_contract) }

  let(:klass) { ::Integration::Contracts::Contract }

  let(:columns) do
    [
      :data_assinatura,
      :data_termino_original,
      :data_termino,
      :data_rescisao,
      :isn_sic,
      :num_contrato,
      :num_spu,
      :cpf_cnpj_financiador,
      :manager_title,
      :grantor_title,
      :creditor_title,
      :status_str,
      :descricao_situacao,
      :decricao_modalidade,
      :tipo_objeto,
      :descricao_objeto,
      :descricao_justificativa,
      :valor_contrato,
      :calculated_valor_aditivo,
      :valor_can_rstpg,
      :valor_atualizado_concedente,
      :calculated_valor_empenhado,
      :calculated_valor_pago
    ]
  end

  it 'spreadsheet_header' do
    expected = columns.map{|column| klass.human_attribute_name(column)}

    expect(::Integration::Contracts::Contract::SpreadsheetPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    data_assinatura = I18n.l(contract.data_assinatura.to_date)
    data_processamento = I18n.l(contract.data_processamento.to_date)
    data_termino = I18n.l(contract.data_termino.to_date)
    data_publicacao_portal = I18n.l(contract.data_publicacao_portal.to_date)

    manager_title = contract.manager_title || contract.cod_gestora
    grantor_title = contract.grantor_title || contract.cod_concedente
    creditor_title = contract.descricao_nome_credor

    expected = [
      data_assinatura,
      contract.send(:data_termino_original),
      data_termino,
      contract.send(:data_rescisao),
      contract.send(:isn_sic),
      contract.send(:num_contrato),
      contract.send(:num_spu),
      contract.send(:cpf_cnpj_financiador),
      manager_title,
      grantor_title,
      creditor_title,
      contract.send(:status_str),
      contract.send(:descricao_situacao),
      contract.send(:decricao_modalidade),
      contract.send(:tipo_objeto),
      contract.send(:descricao_objeto),
      contract.send(:descricao_justificativa),
      contract.send(:valor_contrato),
      contract.send(:calculated_valor_aditivo),
      contract.send(:valor_can_rstpg),
      contract.send(:valor_atualizado_concedente),
      contract.send(:calculated_valor_empenhado),
      contract.send(:calculated_valor_pago)
    ]

    result = spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
