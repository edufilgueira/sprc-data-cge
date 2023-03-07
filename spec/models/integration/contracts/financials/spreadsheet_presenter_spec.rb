require 'rails_helper'

describe Integration::Contracts::Financials::SpreadsheetPresenter do

  subject(:spreadsheet_presenter) do
    ::Integration::Contracts::Financials::SpreadsheetPresenter.new(financial)
  end

  let(:financial) { create(:integration_contracts_financial) }

  let(:klass) { ::Integration::Contracts::Financial }

  let(:columns) do
    [
      :num_documento,
      :data_documento,
      :valor_documento,
      :num_pagamento,
      :data_pagamento,
      :valor_pagamento
    ]
  end

  it 'spreadsheet_header' do
    expected = columns.map{ |column| klass.human_attribute_name(column) }

    expect(::Integration::Contracts::Financials::SpreadsheetPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      financial.num_documento,
      I18n.l(financial.data_documento.to_date),
      financial.valor_documento,
      financial.num_pagamento,
      I18n.l(financial.data_pagamento.to_date),
      financial.valor_pagamento
    ]

    result = spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
