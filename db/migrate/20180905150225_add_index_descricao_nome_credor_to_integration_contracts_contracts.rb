class AddIndexDescricaoNomeCredorToIntegrationContractsContracts < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_contracts_contracts, :descricao_nome_credor
  end
end
