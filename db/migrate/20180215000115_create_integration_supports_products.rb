class CreateIntegrationSupportsProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_products do |t|
      t.string :codigo
      t.string :titulo
    end
    add_index :integration_supports_products, :codigo, name: :isp_codigo
  end
end
