class AddCodSituacaoFuncionalToIntegrationServersServerSalary < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_servers_server_salaries, :cod_situacao_funcional, :string
    add_column :integration_servers_server_salaries, :functional_status, :integer
    add_column :integration_servers_server_salaries, :status_situacao_funcional, :string
    
  end
end
