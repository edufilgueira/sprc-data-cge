require 'rails_helper'

describe Integration::Expenses::ProfitTransfer::SpreadsheetPresenter do

  subject(:spreadsheet_presenter) do
    Integration::Expenses::ProfitTransfer::SpreadsheetPresenter.new(profit_transfer)
  end

  let(:organ) { create(:integration_supports_organ, orgao_sfp: false) }

  let(:profit_transfer) { create(:integration_expenses_profit_transfer) }

  let(:klass) { Integration::Expenses::ProfitTransfer }

  let(:columns) do
    [
      :exercicio,
      :numero,
      :date_of_issue,
      :management_unit_title,
      :executing_unit_title,
      :budget_unit_title,
      :creditor_nome,

      :function_title,
      :sub_function_title,
      :government_program_title,
      :government_action_title,
      :administrative_region_title,
      :expense_nature_title,
      :resource_source_title,
      :expense_type_title,

      :valor,
      :valor_pago,

      :calculated_valor_final,
      :calculated_valor_pago_final,
      :calculated_valor_suplementado,
      :calculated_valor_anulado,
      :calculated_valor_pago_anulado
    ]
  end

  it 'spreadsheet_header' do
    expected = columns.map{|column| I18n.t("integration/expenses/profit_transfer.spreadsheet.worksheets.default.header.#{column}") }

    expect(Integration::Expenses::ProfitTransfer::SpreadsheetPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      profit_transfer.exercicio,
      profit_transfer.numero,
      I18n.l(profit_transfer.date_of_issue),
      profit_transfer.management_unit_title,
      profit_transfer.budget_unit_title,
      profit_transfer.executing_unit_title,
      profit_transfer.creditor_nome,
      profit_transfer.function_title,
      profit_transfer.sub_function_title,
      profit_transfer.government_program_title,
      profit_transfer.government_action_title,
      profit_transfer.administrative_region_title,
      profit_transfer.expense_nature_title,
      profit_transfer.resource_source_title,
      profit_transfer.expense_type_title,
      profit_transfer.valor,
      profit_transfer.valor_pago,
      profit_transfer.calculated_valor_final,
      profit_transfer.calculated_valor_pago_final,
      profit_transfer.calculated_valor_suplementado,
      profit_transfer.calculated_valor_anulado,
      profit_transfer.calculated_valor_pago_anulado
    ]

    result = spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
