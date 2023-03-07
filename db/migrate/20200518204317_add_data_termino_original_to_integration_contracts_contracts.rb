class AddDataTerminoOriginalToIntegrationContractsContracts < ActiveRecord::Migration[5.0]
  def change
  	add_column :integration_contracts_contracts, :data_termino_original, :datetime
    add_index :integration_contracts_contracts, :data_termino_original, name: :icc_data_termino_original
  end
end
