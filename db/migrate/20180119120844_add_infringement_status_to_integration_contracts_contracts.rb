class AddInfringementStatusToIntegrationContractsContracts < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_contracts_contracts, :infringement_status, :integer
    add_index :integration_contracts_contracts, :infringement_status
  end
end
