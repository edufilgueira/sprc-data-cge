require 'rails_helper'

describe Integration::Expenses::BudgetBalance::SpreadsheetPresenter do

  subject(:spreadsheet_presenter) do
    Integration::Expenses::BudgetBalance::SpreadsheetPresenter.new(budget_balance)
  end

  let(:organ) { create(:integration_supports_organ, orgao_sfp: false) }

  let(:budget_balance) { create(:integration_expenses_budget_balance) }

  let(:klass) { Integration::Expenses::BudgetBalance }

  let(:columns) do
    [
      :year,
      :month,
      :secretary_title,
      :organ_title,

      :function_title,
      :sub_function_title,
      :government_program_title,
      :government_action_title,
      :administrative_region_title,
      :expense_nature_title,
      :qualified_resource_source_title,
      :finance_group_title,

      :calculated_valor_orcamento_inicial,
      :calculated_valor_orcamento_atualizado,
      :calculated_valor_empenhado,
      :calculated_valor_liquidado,
      :calculated_valor_pago
    ]
  end

  it 'spreadsheet_header' do
    expected = columns.map{|column| I18n.t("integration/expenses/budget_balance.spreadsheet.worksheets.default.header.#{column}") }

    expect(Integration::Expenses::BudgetBalance::SpreadsheetPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      budget_balance.year,
      budget_balance.month,
      budget_balance.secretary_title,
      budget_balance.organ_title,
      budget_balance.function_title,
      budget_balance.sub_function_title,
      budget_balance.government_program_title,
      budget_balance.government_action_title,
      budget_balance.administrative_region_title,
      budget_balance.expense_nature_title,
      budget_balance.qualified_resource_source_title,
      budget_balance.finance_group_title,
      budget_balance.calculated_valor_orcamento_inicial,
      budget_balance.calculated_valor_orcamento_atualizado,
      budget_balance.calculated_valor_empenhado,
      budget_balance.calculated_valor_liquidado,
      budget_balance.calculated_valor_pago
    ]

    result = spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
