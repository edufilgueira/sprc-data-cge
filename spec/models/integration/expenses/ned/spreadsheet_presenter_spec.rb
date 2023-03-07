require 'rails_helper'

describe Integration::Expenses::Ned::SpreadsheetPresenter do

  subject(:spreadsheet_presenter) do
    Integration::Expenses::Ned::SpreadsheetPresenter.new(ned)
  end

  let(:organ) { create(:integration_supports_organ, orgao_sfp: false) }

  let(:ned) { create(:integration_expenses_ned) }

  let(:klass) { Integration::Expenses::Ned }

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
    expected = columns.map{|column| I18n.t("integration/expenses/ned.spreadsheet.worksheets.default.header.#{column}") }

    expect(Integration::Expenses::Ned::SpreadsheetPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      ned.exercicio,
      ned.numero,
      I18n.l(ned.date_of_issue),
      ned.management_unit_title,
      ned.budget_unit_title,
      ned.executing_unit_title,
      ned.creditor_nome,
      ned.function_title,
      ned.sub_function_title,
      ned.government_program_title,
      ned.government_action_title,
      ned.administrative_region_title,
      ned.expense_nature_title,
      ned.resource_source_title,
      ned.expense_type_title,
      ned.valor,
      ned.valor_pago,
      ned.calculated_valor_final,
      ned.calculated_valor_pago_final,
      ned.calculated_valor_suplementado,
      ned.calculated_valor_anulado,
      ned.calculated_valor_pago_anulado
    ]

    result = spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
