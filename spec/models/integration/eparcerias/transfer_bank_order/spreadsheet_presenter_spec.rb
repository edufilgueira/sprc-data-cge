require 'rails_helper'

describe Integration::Eparcerias::TransferBankOrder::SpreadsheetPresenter do
  subject(:spreadsheet_presenter) do
    ::Integration::Eparcerias::TransferBankOrder::SpreadsheetPresenter.new(transfer_bank_order)
  end

  let(:transfer_bank_order) { create(:integration_eparcerias_transfer_bank_order) }

  let(:klass) { ::Integration::Eparcerias::TransferBankOrder }

  let(:columns) do
    [
      :numero_ordem_bancaria,
      :tipo_ordem_bancaria,
      :nome_benceficiario,
      :valor_ordem_bancaria,
      :data_pagamento
    ]
  end

  it 'spreadsheet_header' do
    expected = columns.map{ |column| klass.human_attribute_name(column) }

    expect(::Integration::Eparcerias::TransferBankOrder::SpreadsheetPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      transfer_bank_order.numero_ordem_bancaria,
      transfer_bank_order.tipo_ordem_bancaria,
      transfer_bank_order.nome_benceficiario,
      transfer_bank_order.valor_ordem_bancaria,
      I18n.l(transfer_bank_order.data_pagamento.to_date)
    ]

    result = spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
