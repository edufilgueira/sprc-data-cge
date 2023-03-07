class CreateIntegrationSupportsEconomicCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_economic_categories do |t|
      t.string :codigo_categoria_economica
      t.string :titulo
    end
    add_index :integration_supports_economic_categories, :codigo_categoria_economica, name: :isec_codigo_categoria_economica
  end
end
