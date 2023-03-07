class RenameIntegrationServersServerRolesToIntegrationSupportsServerRoles < ActiveRecord::Migration[5.0]
  def change
    rename_table :integration_servers_server_roles, :integration_supports_server_roles
  end
end
