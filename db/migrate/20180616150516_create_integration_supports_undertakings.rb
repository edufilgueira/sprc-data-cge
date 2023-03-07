class CreateIntegrationSupportsUndertakings < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_undertakings do |t|
      t.string :descricao

      t.timestamps
    end
  end
end
