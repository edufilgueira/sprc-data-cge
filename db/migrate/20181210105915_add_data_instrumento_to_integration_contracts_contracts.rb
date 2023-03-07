class AddDataInstrumentoToIntegrationContractsContracts < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_contracts_contracts, :data_instrumento, :date
    add_index :integration_contracts_contracts, :data_instrumento
  end
end
