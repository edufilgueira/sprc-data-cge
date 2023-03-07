class CreateIntegrationConstructionsDaePhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_constructions_dae_photos do |t|
      t.references :integration_constructions_dae, foreign_key: true, index: { name: 'index_i_c_dae_photos_on_integration_constructions_dae_id' }
      t.string :codigo_obra
      t.integer :id_medicao
      t.string :descricao_conta_associada
      t.string :legenda
      t.string :url_foto

      t.timestamps
    end
  end
end
