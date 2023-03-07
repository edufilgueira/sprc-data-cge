class AddDateToIntegrationServersServerSalaries < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_servers_server_salaries, :date, :string
    add_index :integration_servers_server_salaries, :date
  end
end
