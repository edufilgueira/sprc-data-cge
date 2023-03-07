class RemoveAssociationsColumnsFromIntegrationServersProceeds < ActiveRecord::Migration[5.0]
  def change
    remove_column :integration_servers_proceeds, :integration_servers_registration_id
    remove_column :integration_servers_proceeds, :integration_servers_proceed_type_id
  end
end
