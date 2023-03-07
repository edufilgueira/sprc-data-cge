class AddIndexToIntegrationContractsContractsAccountabilityStatus < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_contracts_contracts, :accountability_status, name: :icc_accountability_status
  end
end
