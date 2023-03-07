class AddConfidentialToIntegrationContractsContract < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_contracts_contracts, :confidential, :boolean
  end
end
