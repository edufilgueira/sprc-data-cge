class AddIndexUpdatedAtToServerSalary < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_servers_server_salaries, :updated_at
  end
end
