class AddDataRescisaoToIntegrationContractsContracts < ActiveRecord::Migration[5.0]
  def change
  	add_column :integration_contracts_contracts, :data_rescisao, :datetime
    add_index :integration_contracts_contracts, :data_rescisao, name: :icc_data_rescisao
  end
end