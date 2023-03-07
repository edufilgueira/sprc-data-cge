class CreateIntegrationConstructionsDerMeasurements < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_constructions_der_measurements do |t|
      t.references :integration_constructions_der, foreign_key: true, index: { name: 'index_i_c_der_measurements_on_integration_constructions_der_id' }
      t.integer :id_medicao
      t.integer :id_obra
      t.integer :id_status
      t.string :ano_mes
      t.date :ano_mes_date
      t.string :numero_contrato_der
      t.string :numero_contrato_sac
      t.integer :numero_medicao
      t.string :rodovia
      t.string :status
      t.string :status_medicao
      t.decimal :valor_medido

      t.timestamps
    end
  end
end
