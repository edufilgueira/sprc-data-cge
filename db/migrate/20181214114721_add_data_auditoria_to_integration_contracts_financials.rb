class AddDataAuditoriaToIntegrationContractsFinancials < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_contracts_financials, :data_auditoria, :date
    add_index :integration_contracts_financials, :data_auditoria
  end
end
