#
# Cria planilha de despesas
#

class Integration::Expenses::BudgetBalances::CreateSpreadsheet < ::Integration::Expenses::BaseCreateSpreadsheet

  private

  def transparency_id
    :budget_balance
  end

  def resource_klass
    Integration::Expenses::BudgetBalance
  end

  def associations
    [
      :secretary,
      :organ,
      :function,
      :sub_function,
      :government_program,
      :government_action,
      :administrative_region,
      :expense_nature,
      :qualified_resource_source,
      :finance_group
    ]
  end

  def resources
    resource_klass.
      from_month_range(year, month_start, month_end).
      includes(associations).
      references(associations).
      where('integration_supports_organs.poder = ?', 'EXECUTIVO')
  end

  def file_name_prefix
    :despesas_poder_executivo
  end

  def presenter_klass
    Integration::Expenses::BudgetBalance::SpreadsheetPresenter
  end

  def spreadsheet_dir_path
    Rails.root.to_s + "/public/files/downloads/integration/expenses/#{transparency_id.to_s.pluralize}/#{year}_#{month_start}_#{month_end}/"
  end

  def file_name(extension='xlsx')
    "#{file_name_prefix}_#{year}_#{month_start}_#{month_end}.#{extension}"
  end
end
