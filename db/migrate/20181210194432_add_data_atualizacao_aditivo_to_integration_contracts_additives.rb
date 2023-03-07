class AddDataAtualizacaoAditivoToIntegrationContractsAdditives < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_contracts_additives, :data_atualizacao_aditivo, :date
    add_index :integration_contracts_additives, :data_atualizacao_aditivo, name: :ica_daa
  end
end
