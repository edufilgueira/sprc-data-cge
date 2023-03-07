class CreateIntegrationCityUndertakingsCityUndertakings < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_city_undertakings_city_undertakings do |t|
      t.string :tipo_despesa
      t.string :sic
      t.string :mapp
      t.string :municipio
      t.integer :expense
      t.decimal :valor_programado1
      t.decimal :valor_programado2
      t.decimal :valor_programado3
      t.decimal :valor_programado4
      t.decimal :valor_programado5
      t.decimal :valor_programado6
      t.decimal :valor_programado7
      t.decimal :valor_programado8
      t.decimal :valor_executado1
      t.decimal :valor_executado2
      t.decimal :valor_executado3
      t.decimal :valor_executado4
      t.decimal :valor_executado5
      t.decimal :valor_executado6
      t.decimal :valor_executado7
      t.decimal :valor_executado8
      t.integer :sprc_city_id
      t.references :organ, foreign_key: { to_table: :integration_supports_organs }, index: { name: 'index_integration_c_utaking_on_integration_s_organs_id' }
      t.references :creditor, foreign_key: { to_table: :integration_supports_creditors }, index: { name: 'index_integration_c_utaking_on_integration_creditor_id' }
      t.references :undertaking, foreign_key: { to_table: :integration_supports_undertakings }, index: { name: 'index_integration_c_utaking_on_integration_undertaking_id' }

      t.timestamps
    end
  end
end
