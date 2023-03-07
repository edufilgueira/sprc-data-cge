class RenameOrganIdToIntegrationOrganIdInIntegrationServersRegistration < ActiveRecord::Migration[5.0]
  def change
    remove_index :integration_servers_registrations, :organ_id
    rename_column :integration_servers_registrations, :organ_id, :integration_supports_organ_id
    add_index :integration_servers_registrations, :integration_supports_organ_id, name: :isr_integration_supports_organ_id
  end
end
