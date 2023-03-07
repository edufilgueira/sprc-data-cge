class CreateIntegrationSupportsExpenseNatureItems < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_expense_nature_items do |t|
      t.string :codigo_item_natureza
      t.string :titulo
    end
    add_index :integration_supports_expense_nature_items, :codigo_item_natureza, name: :iseni_codigo_item_natureza
  end
end
