class CreateIntegrationSupportsSubProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_sub_products do |t|
      t.string :codigo
      t.string :codigo_produto
      t.string :titulo
    end
    add_index :integration_supports_sub_products, :codigo, name: :issp_codigo
    add_index :integration_supports_sub_products, :codigo_produto, name: :issp_codigo_produto
  end
end
