class AddFunctionalStatusToIntegrationServersRegistrations < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_servers_registrations, :functional_status, :integer
    add_index :integration_servers_registrations, :functional_status, name: :isr_functional_status
  end
end
