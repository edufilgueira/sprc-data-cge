class AddIndexesToIntegrationContractsInfringements < ActiveRecord::Migration[5.0]
  def change

    add_index :integration_contracts_infringements, :cod_financiador, name: :icinfrin_cod_financiador
    add_index :integration_contracts_infringements, :cod_gestora, name: :icinfrin_cod_gestora
    add_index :integration_contracts_infringements, :data_lancamento, name: :icinfrin_data_lancamento
    add_index :integration_contracts_infringements, :data_processamento, name: :icinfrin_data_processamento
    add_index :integration_contracts_infringements, :data_termino_atual, name: :icinfrin_data_termino_atual
    add_index :integration_contracts_infringements, :data_ultima_pcontas, name: :icinfrin_data_ultima_pcontas
    add_index :integration_contracts_infringements, :data_ultima_pagto, name: :icinfrin_data_ultima_pagto
    add_index :integration_contracts_infringements, :isn_sic, name: :icinfrin_isn_sic

  end
end
