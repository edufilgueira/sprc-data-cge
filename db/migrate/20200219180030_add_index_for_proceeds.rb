class AddIndexForProceeds < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_servers_proceeds, [:full_matricula, :num_ano, :num_mes], name: "index_for_full_matricula_num_ano_num_mes"
  end
end
