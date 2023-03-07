class AlterIndexProceedImport < ActiveRecord::Migration[5.0]
  def change
    remove_index :integration_servers_proceeds, name: "integration_servers_proceeds_pk_index"
    add_index :integration_servers_proceeds, [:cod_provento, :cod_processamento, :num_ano, :num_mes, :cod_orgao, :dsc_matricula], name: "integration_servers_proceeds_pk_index"
  end
end
