class RenameColumnDataAditivoToDataAuditoriaInIntegrationContractsContracts < ActiveRecord::Migration[5.0]
  def change
    rename_column :integration_contracts_contracts, :data_aditivo, :data_auditoria
  end
end
