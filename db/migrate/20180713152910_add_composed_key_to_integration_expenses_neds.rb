class AddComposedKeyToIntegrationExpensesNeds < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_expenses_neds, :composed_key, :string
    add_index :integration_expenses_neds, :composed_key, name: :ien_composed_key
  end
end
