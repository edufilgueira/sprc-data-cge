class RemoveAssociationColumnsFromIntegrationServersRegistrations < ActiveRecord::Migration[5.0]
  def change
    remove_column :integration_servers_registrations, :integration_supports_organ_id, :integer
    remove_column :integration_servers_registrations, :integration_servers_server_id, :integer
  end
end
