class AddIndexesToIntegrationServersRegistrations < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_servers_registrations, :dsc_cpf, name: :isr_dsc_cpf
    add_index :integration_servers_registrations, :cod_situacao_funcional, name: :isr_cod_situacao_funcional
  end
end
