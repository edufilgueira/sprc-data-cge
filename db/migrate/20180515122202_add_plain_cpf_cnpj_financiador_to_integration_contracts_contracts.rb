class AddPlainCpfCnpjFinanciadorToIntegrationContractsContracts < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_contracts_contracts, :plain_cpf_cnpj_financiador, :string
    add_index :integration_contracts_contracts, :plain_cpf_cnpj_financiador, name: :icc_plain_cpf_cnpj_financiador
  end
end
