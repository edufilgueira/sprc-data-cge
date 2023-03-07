class AddActiveFunctionalStatusToIntegrationServersRegistrations < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_servers_registrations, :active_functional_status, :boolean
    add_index :integration_servers_registrations, :active_functional_status, name: :isr_active_functional_status
  end
end
