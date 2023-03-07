class AddRoleIdToIntegrationServersServerSalaries < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_servers_server_salaries, :integration_servers_server_role_id, :integer
    add_index :integration_servers_server_salaries, :integration_servers_server_role_id, name: :isss_role_id
  end
end
