class AddAccountabilityStatusToIntegrationContractsContracts < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_contracts_contracts, :accountability_status, :string
  end
end
