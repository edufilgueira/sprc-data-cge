class AddMonthAndYearToIntegrationExpensesBudgetBalances < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_expenses_budget_balances, :year, :integer
    add_index :integration_expenses_budget_balances, :year, name: :iebb_year
    add_column :integration_expenses_budget_balances, :month, :integer
    add_index :integration_expenses_budget_balances, :month, name: :iebb_month
  end
end
