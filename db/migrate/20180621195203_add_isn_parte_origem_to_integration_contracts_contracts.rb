class AddIsnParteOrigemToIntegrationContractsContracts < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_contracts_contracts, :isn_parte_origem, :string
    add_index :integration_contracts_contracts, :isn_parte_origem, name: :icc_isn_parte_origem
  end
end
