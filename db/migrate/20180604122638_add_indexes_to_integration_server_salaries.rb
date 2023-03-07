class AddIndexesToIntegrationServerSalaries < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_servers_proceeds, :cod_provento, name: :isp_cod_provento
    add_index :integration_servers_proceeds, :num_ano, name: :isp_num_ano
    add_index :integration_servers_proceeds, :num_mes, name: :isp_num_mes
  end
end
