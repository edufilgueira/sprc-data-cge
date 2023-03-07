class CreateIntegrationSupportsOrganServerRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_organ_server_roles do |t|
      t.integer :integration_supports_organ_id
      t.integer :integration_supports_server_role_id
    end
    add_index :integration_supports_organ_server_roles, :integration_supports_organ_id, name: :ososr_organ_id
    add_index :integration_supports_organ_server_roles, :integration_supports_server_role_id, name: :ososr_server_role_id
  end
end
