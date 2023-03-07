class AddNldComposedKeyToIntegrationExpensesNpds < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_expenses_npds, :nld_composed_key, :string
    add_index :integration_expenses_npds, :nld_composed_key, name: :ien_nld_composed_key
  end
end
