class AddOrganAndSecretaryToIntegrationExpensesBudgetBalances < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_expenses_budget_balances, :integration_supports_organ_id, :integer
    add_index :integration_expenses_budget_balances, :integration_supports_organ_id, name: :iebb_integration_supports_organ_id
    add_column :integration_expenses_budget_balances, :integration_supports_secretary_id, :integer
    add_index :integration_expenses_budget_balances, :integration_supports_secretary_id, name: :iebb_integration_supports_secretary_id
  end
end
