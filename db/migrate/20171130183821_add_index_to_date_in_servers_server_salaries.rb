class AddIndexToDateInServersServerSalaries < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_servers_server_salaries, :date, name: :isss_date
  end
end
