class AddBudgetFieldsToIntegrationExpensesConfigurations < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_expenses_configurations, :budget_balance_wsdl, :string
    add_column :integration_expenses_configurations, :budget_balance_headers_soap_action, :string
    add_column :integration_expenses_configurations, :budget_balance_operation, :string
    add_column :integration_expenses_configurations, :budget_balance_response_path, :string
    add_column :integration_expenses_configurations, :budget_balance_user, :string
    add_column :integration_expenses_configurations, :budget_balance_password, :string
  end
end
