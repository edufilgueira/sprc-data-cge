class AddContractTypeToIntegrationContractsContracts < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_contracts_contracts, :contract_type, :integer
    add_index :integration_contracts_contracts, :contract_type
  end
end
