class AddIndexesToIntegrationContractsAdditives < ActiveRecord::Migration[5.0]
  def change

    add_index :integration_contracts_additives, :data_aditivo, name: :ica_data_aditivo
    add_index :integration_contracts_additives, :data_inicio, name: :ica_data_inicio
    add_index :integration_contracts_additives, :data_publicacao, name: :ica_data_publicacao
    add_index :integration_contracts_additives, :data_termino, name: :ica_data_termino
    add_index :integration_contracts_additives, :flg_tipo_aditivo, name: :ica_flg_tipo_aditivo
    add_index :integration_contracts_additives, :isn_contrato_aditivo, name: :ica_isn_contrato_aditivo
    add_index :integration_contracts_additives, :isn_ig, name: :ica_isn_ig
    add_index :integration_contracts_additives, :isn_sic, name: :ica_isn_sic
    add_index :integration_contracts_additives, :data_publicacao_portal, name: :ica_data_publicacao_portal
    add_index :integration_contracts_additives, :num_aditivo_siconv, name: :ica_num_aditivo_siconv

  end
end
