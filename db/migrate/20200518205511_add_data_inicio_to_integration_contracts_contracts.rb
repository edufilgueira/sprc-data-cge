class AddDataInicioToIntegrationContractsContracts < ActiveRecord::Migration[5.0]
  def change
  	add_column :integration_contracts_contracts, :data_inicio, :datetime
    add_index :integration_contracts_contracts, :data_inicio, name: :icc_data_inicio
  end
end