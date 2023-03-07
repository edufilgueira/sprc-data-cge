require 'rails_helper'

describe Integration::Expenses::Daily::SpreadsheetPresenter do

  subject(:spreadsheet_presenter) do
    Integration::Expenses::Daily::SpreadsheetPresenter.new(daily)
  end

  let(:organ) { create(:integration_supports_organ, orgao_sfp: false) }

  let(:daily) { create(:integration_expenses_daily) }

  let(:klass) { Integration::Expenses::Daily }

  let(:columns) do
    [
      :exercicio,
      :numero,
      :date_of_issue,
      :management_unit_title,
      :executing_unit_title,
      :creditor_nome,
      :calculated_valor_final
    ]
  end

  it 'spreadsheet_header' do
    expected = columns.map{|column| I18n.t("integration/expenses/daily.spreadsheet.worksheets.default.header.#{column}") }

    expect(Integration::Expenses::Daily::SpreadsheetPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      daily.exercicio,
      daily.numero,
      I18n.l(daily.date_of_issue),
      daily.management_unit_title,
      daily.executing_unit_title,
      daily.creditor_nome,
      daily.valor_final
    ]

    result = spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
