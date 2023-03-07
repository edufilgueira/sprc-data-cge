class AddPlainNumContratoToIntegrationContractsContracts < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_contracts_contracts, :plain_num_contrato, :string
    add_index :integration_contracts_contracts, :plain_num_contrato, name: :icc_plain_num_contrato
    add_index :integration_contracts_contracts, :num_contrato, name: :icc_num_contrato
  end
end
