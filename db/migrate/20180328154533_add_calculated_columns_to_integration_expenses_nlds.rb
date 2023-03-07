class AddCalculatedColumnsToIntegrationExpensesNlds < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_expenses_nlds, :calculated_valor_final, :decimal
    add_column :integration_expenses_nlds, :calculated_valor_anulado, :decimal

    add_index :integration_expenses_nlds, :natureza, name: :ienlds_natureza
  end
end
