class CreateIntegrationServersServerRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_servers_server_roles do |t|
      t.string :name
    end
    add_index :integration_servers_server_roles, :name
  end
end
