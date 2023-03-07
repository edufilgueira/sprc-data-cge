class CreateIntegrationConstructionsDaeMeasurements < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_constructions_dae_measurements do |t|
      t.references :integration_constructions_dae, foreign_key: true, index: { name: 'index_i_c_dae_measurements_on_integration_constructions_dae_id' }
      t.string :ano_mes
      t.date :ano_mes_date
      t.string :codigo_obra
      t.datetime :data_fim
      t.datetime :data_inicio
      t.integer :id_servico
      t.integer :id_medicao
      t.string :numero_medicao
      t.decimal :valor_medido

      t.timestamps
    end
  end
end
