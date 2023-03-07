class AddFullMatriculaToIntegrationServersProceeds < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_servers_proceeds, :full_matricula, :string
    add_index :integration_servers_proceeds, :full_matricula, name: :isp_full_matricula
  end
end
