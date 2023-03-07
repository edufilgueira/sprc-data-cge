class RemoveRoleFromIntegrationServersServerSalaries < ActiveRecord::Migration[5.0]
  def change
    remove_column :integration_servers_server_salaries, :role, :string
  end
end
