class AddStatusToIntegrationServersServerSalaries < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_servers_server_salaries, :status, :integer
    add_index :integration_servers_server_salaries, :status
  end
end
