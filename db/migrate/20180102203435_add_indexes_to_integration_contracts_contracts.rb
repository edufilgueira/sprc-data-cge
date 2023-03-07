class AddIndexesToIntegrationContractsContracts < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_contracts_contracts, :data_assinatura, name: :icc_data_assinatura
    add_index :integration_contracts_contracts, :data_processamento, name: :icc_data_processamento
    add_index :integration_contracts_contracts, :data_termino, name: :icc_data_termino
    add_index :integration_contracts_contracts, :isn_modalidade, name: :icc_isn_modalidade
    add_index :integration_contracts_contracts, :flg_tipo, name: :icc_flg_tipo
  end
end
