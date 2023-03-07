class AddDataAuditoriaToIntegrationContractsAdjustments < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_contracts_adjustments, :data_auditoria, :date
    add_index :integration_contracts_adjustments, :data_auditoria
  end
end
