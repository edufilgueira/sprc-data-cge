class RenameIntegrationServerSalariesServerRoleToIntegrationSupportsServerRole < ActiveRecord::Migration[5.0]
  def change
    rename_column :integration_servers_server_salaries, :integration_servers_server_role_id, :integration_supports_server_role_id
  end
end
