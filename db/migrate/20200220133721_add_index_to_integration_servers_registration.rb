class AddIndexToIntegrationServersRegistration < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_servers_registrations, [:cod_orgao]
  end
end
