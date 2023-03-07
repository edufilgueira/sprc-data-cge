class AddNedComposedKeyToIntegrationExpensesNlds < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_expenses_nlds, :ned_composed_key, :string
    add_index :integration_expenses_nlds, :ned_composed_key, name: :ien_ned_composed_key
  end
end
