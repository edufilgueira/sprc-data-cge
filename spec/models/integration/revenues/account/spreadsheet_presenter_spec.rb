require 'rails_helper'

describe Integration::Revenues::Account::SpreadsheetPresenter do

  subject(:spreadsheet_presenter) do
    Integration::Revenues::Account::SpreadsheetPresenter.new(account)
  end

  let(:organ) { create(:integration_supports_organ, orgao_sfp: false) }

  let(:revenue_nature) { create(:integration_supports_revenue_nature, codigo: '112109953') }
  let(:revenue) { create(:integration_revenues_revenue, unidade: organ.codigo_orgao) }
  let(:account) { create(:integration_revenues_account, revenue: revenue, conta_corrente: "#{revenue_nature.codigo}.20500") }

  let(:klass) { Integration::Revenues::Account }

  let(:columns) do
    [
      :year,
      :month,
      :unidade,
      :poder,
      :administracao,
      :conta_contabil,
      :titulo,
      :natureza_da_conta,

      :conta_corrente,
      :natureza_credito,
      :valor_credito,
      :natureza_debito,
      :valor_debito,
      :valor_inicial,
      :natureza_inicial,
      :codigo_natureza_receita,
      :natureza_receita,
    ]
  end

  it 'spreadsheet_header' do
    expected = columns.map{|column| I18n.t("integration/revenues/account.spreadsheet.worksheets.default.header.#{column}") }

    expect(Integration::Revenues::Account::SpreadsheetPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      revenue.year,
      revenue.month,
      organ.title,
      revenue.poder,
      revenue.administracao,
      revenue.conta_contabil,
      revenue.titulo,
      revenue.natureza_da_conta,
      account.conta_corrente,
      account.natureza_credito,
      account.valor_credito,
      account.natureza_debito,
      account.valor_debito,
      account.valor_inicial,
      account.natureza_inicial,
      account.codigo_natureza_receita,
      revenue_nature.descricao
    ]

    result = spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
