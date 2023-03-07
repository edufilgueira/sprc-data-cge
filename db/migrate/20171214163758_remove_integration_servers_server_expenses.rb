class RemoveIntegrationServersServerExpenses < ActiveRecord::Migration[5.0]
  def change
    drop_table :integration_servers_server_expenses
  end
end
