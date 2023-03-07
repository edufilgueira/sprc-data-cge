class ChangeDateTypeInIntegrationServersSalaries < ActiveRecord::Migration[5.0]
  def change
    remove_column :integration_servers_server_salaries, :date, :string
    add_column :integration_servers_server_salaries, :date, :date
  end
end
