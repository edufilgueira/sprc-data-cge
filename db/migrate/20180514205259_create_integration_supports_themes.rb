class CreateIntegrationSupportsThemes < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_themes do |t|
      t.string :codigo_tema
      t.string :descricao_tema
    end
    add_index :integration_supports_themes, :codigo_tema, name: :ist_codigo_tema
  end
end
