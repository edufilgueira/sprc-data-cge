class CreateIntegrationResultsStrategicIndicators < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_results_strategic_indicators do |t|
      t.jsonb :eixo
      t.string :resultado
      t.string :indicador
      t.string :unidade
      t.string :sigla_orgao
      t.string :orgao
      t.jsonb :valores_realizados
      t.jsonb :valores_atuais

      t.timestamps

      t.references :organ, foreign_key: { to_table: :integration_supports_organs }, index: { name: 'index_ir_strategic_indicators_on_integration_s_organs_id' }
      t.references :axis, foreign_key: { to_table: :integration_supports_axes }, index: { name: 'index_ir_strategic_indicators_on_integration_s_axes_id' }
    end
  end
end
