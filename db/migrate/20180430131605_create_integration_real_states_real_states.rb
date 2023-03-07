class CreateIntegrationRealStatesRealStates < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_real_states_real_states do |t|
      t.references :manager, foreign_key: { to_table: :integration_supports_organs }, index: { name: 'index_integration_rs_real_states_on_integration_s_organs_id' }
      t.references :property_type, foreign_key: { to_table: :integration_supports_real_states_property_types }, index: { name: 'index_integration_rs_real_states_on_property_types_id' }
      t.references :occupation_type, foreign_key: { to_table: :integration_supports_real_states_occupation_types }, index: { name: 'index_integration_rs_real_states_on_occupation_types_id' }
      t.string :service_id
      t.string :descricao_imovel
      t.string :estado
      t.string :municipio
      t.decimal :area_projecao_construcao
      t.decimal :area_medida_in_loco
      t.decimal :area_registrada
      t.decimal :frente
      t.decimal :fundo
      t.decimal :lateral_direita
      t.decimal :lateral_esquerda
      t.decimal :taxa_ocupacao
      t.decimal :fracao_ideal
      t.string :numero_imovel
      t.string :utm_zona
      t.string :bairro
      t.string :cep
      t.string :endereco
      t.string :complemento
      t.string :lote
      t.string :quadra

      t.timestamps
    end
  end
end
