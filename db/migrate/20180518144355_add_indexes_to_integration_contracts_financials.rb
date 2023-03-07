class AddIndexesToIntegrationContractsFinancials < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_contracts_financials, :ano_documento, name: :icfin_ano_documento
    add_index :integration_contracts_financials, :cod_entidade, name: :icfin_cod_entidade
    add_index :integration_contracts_financials, :cod_fonte, name: :icfin_cod_fonte
    add_index :integration_contracts_financials, :cod_gestor, name: :icfin_cod_gestor
    add_index :integration_contracts_financials, :data_documento, name: :icfin_data_documento
    add_index :integration_contracts_financials, :data_pagamento, name: :icfin_data_pagamento
    add_index :integration_contracts_financials, :data_processamento, name: :icfin_data_processamento
    add_index :integration_contracts_financials, :flg_sic, name: :icfin_flg_sic
    add_index :integration_contracts_financials, :isn_sic, name: :icfin_isn_sic
    add_index :integration_contracts_financials, :num_pagamento, name: :icfin_num_pagamento
    add_index :integration_contracts_financials, :num_documento, name: :icfin_num_documento
    add_index :integration_contracts_financials, :cod_credor, name: :icfin_cod_credor
  end
end
