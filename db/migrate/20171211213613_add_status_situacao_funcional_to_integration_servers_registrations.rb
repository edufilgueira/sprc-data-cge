class AddStatusSituacaoFuncionalToIntegrationServersRegistrations < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_servers_registrations, :status_situacao_funcional, :string
    add_index :integration_servers_registrations, :status_situacao_funcional, name: :isr_status_situacao_funcional
  end
end
