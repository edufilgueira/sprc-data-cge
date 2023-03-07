class AddFullMatriculaToIntegrationServersRegistrations < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_servers_registrations, :full_matricula, :string
    add_index :integration_servers_registrations, :full_matricula, name: :isr_full_matricula
  end
end
