class AddIntegrationSupportsOrganIntegrationServersServerSalaries < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_servers_server_salaries, :integration_supports_organ_id, :integer
    add_index :integration_servers_server_salaries, :integration_supports_organ_id, name: :isss_organ_id
  end
end
