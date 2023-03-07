class RenameColumnDataAditivoToDataAuditoriaInIntegrationContractsAdditives < ActiveRecord::Migration[5.0]
  def change
    rename_column :integration_contracts_additives, :data_atualizacao_aditivo, :data_auditoria
  end
end
