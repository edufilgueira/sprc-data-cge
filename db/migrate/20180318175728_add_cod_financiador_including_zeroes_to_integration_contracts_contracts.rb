class AddCodFinanciadorIncludingZeroesToIntegrationContractsContracts < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_contracts_contracts, :cod_financiador_including_zeroes, :string
    add_index :integration_contracts_contracts, :cod_financiador_including_zeroes, name: :icc_cod_financiador_including_zeroes
    add_index :integration_contracts_contracts, :cod_secretaria, name: :icc_cod_secretaria
    add_index :integration_contracts_contracts, :cod_concedente, name: :icc_cod_concedente
    add_index :integration_contracts_contracts, :cod_financiador, name: :icc_cod_financiador
    add_index :integration_contracts_contracts, :cod_gestora, name: :icc_cod_gestora
    add_index :integration_contracts_contracts, :cod_orgao, name: :icc_cod_orgao
  end
end
