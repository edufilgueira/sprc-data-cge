class AddIndexesToIntegrationRealStatesRealState < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_real_states_real_states, :descricao_imovel
    add_index :integration_real_states_real_states, :municipio
    add_index :integration_real_states_real_states, :numero_imovel
    add_index :integration_real_states_real_states, :bairro
    add_index :integration_real_states_real_states, :cep
    add_index :integration_real_states_real_states, :endereco
    add_index :integration_real_states_real_states, :complemento
    add_index :integration_real_states_real_states, :lote
    add_index :integration_real_states_real_states, :quadra
    add_index :integration_supports_real_states_occupation_types, :title, name: 'index_integration_sup_real_states_occupation_types_on_title'
    add_index :integration_supports_real_states_property_types, :title, name: 'index_integration_sup_real_states_property_types_on_title'
  end
end
