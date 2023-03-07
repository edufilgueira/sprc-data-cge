class AddDataPublicacaoDoeAndDescricaoNomeCredorToIntegrationContractsContracts < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_contracts_contracts, :data_publicacao_doe, :datetime
    add_column :integration_contracts_contracts, :descricao_nome_credor, :text
  end
end
