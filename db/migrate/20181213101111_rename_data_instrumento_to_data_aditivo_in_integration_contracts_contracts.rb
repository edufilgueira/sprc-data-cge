class RenameDataInstrumentoToDataAditivoInIntegrationContractsContracts < ActiveRecord::Migration[5.0]
  def change
    rename_column :integration_contracts_contracts, :data_instrumento, :data_aditivo
  end
end
