class AddGovernmentProgramIdToIntegrationExpensesBudgetBalances < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_expenses_budget_balances, :integration_supports_government_program_id, :integer
    add_index :integration_expenses_budget_balances, :integration_supports_government_program_id, name: :iebb_government_program_id
  end
end
