class RemoveAssociationColumnsFromIntegrationServersServerSalaries < ActiveRecord::Migration[5.0]
  def change
    remove_column :integration_servers_server_salaries, :integration_supports_organ_id, :integer
  end
end
