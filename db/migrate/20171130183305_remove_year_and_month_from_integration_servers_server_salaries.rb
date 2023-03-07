class RemoveYearAndMonthFromIntegrationServersServerSalaries < ActiveRecord::Migration[5.0]
  def change
    remove_index :integration_servers_server_salaries, :year
    remove_index :integration_servers_server_salaries, :month

    remove_column :integration_servers_server_salaries, :year, :integer
    remove_column :integration_servers_server_salaries, :month, :integer
  end
end
