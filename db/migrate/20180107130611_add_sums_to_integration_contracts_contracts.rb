class AddSumsToIntegrationContractsContracts < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_contracts_contracts, :calculated_valor_aditivo, :decimal
    add_column :integration_contracts_contracts, :calculated_valor_ajuste, :decimal
    add_column :integration_contracts_contracts, :calculated_valor_empenhado, :decimal
    add_column :integration_contracts_contracts, :calculated_valor_pago, :decimal
  end
end
