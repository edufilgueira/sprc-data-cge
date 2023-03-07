class AddComposedKeyToIntegrationExpensesNlds < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_expenses_nlds, :composed_key, :string
    add_index :integration_expenses_nlds, :composed_key, name: :ienlds_composed_key
  end
end
