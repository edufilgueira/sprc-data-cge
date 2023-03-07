class AddDescricaoSituacaoToIntegrationContractsContracts < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_contracts_contracts, :descricao_situacao, :string
    add_index :integration_contracts_contracts, :descricao_situacao, name: :icc_descricao_situacao
  end
end
