class AddServerNameToIntegrationServersServerSalary < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_servers_server_salaries, :server_name, :string
    add_index :integration_servers_server_salaries, :server_name
  end
end
