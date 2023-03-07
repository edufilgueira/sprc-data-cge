class AddCalculatedColumnsToIntegrationExpensesNpfs < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_expenses_npfs, :calculated_valor_final, :decimal
    add_column :integration_expenses_npfs, :calculated_valor_suplementado, :decimal
    add_column :integration_expenses_npfs, :calculated_valor_anulado, :decimal

    add_index :integration_expenses_npfs, :natureza, name: :ienpfs_natureza
  end
end
