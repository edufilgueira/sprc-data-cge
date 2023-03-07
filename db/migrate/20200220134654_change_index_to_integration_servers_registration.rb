class ChangeIndexToIntegrationServersRegistration < ActiveRecord::Migration[5.0]
  def up
    #nome antigo isr_active_functional_status
    remove_index :integration_servers_registrations, name: "isr_active_functional_status"
    add_index :integration_servers_registrations, [:active_functional_status], where: 'active_functional_status is true', name: 'index_isr_on_active_functional_status'
  end

  def down
    remove_index :integration_servers_registrations, name: "index_isr_on_active_functional_status"
    add_index :integration_servers_registrations, :active_functional_status, name: :isr_active_functional_status
  end
end
