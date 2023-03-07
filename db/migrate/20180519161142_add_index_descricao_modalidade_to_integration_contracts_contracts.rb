class AddIndexDescricaoModalidadeToIntegrationContractsContracts < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_contracts_contracts, :decricao_modalidade, name: :icc_decricao_modalidade
  end
end
