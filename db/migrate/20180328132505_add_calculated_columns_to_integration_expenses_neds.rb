class AddCalculatedColumnsToIntegrationExpensesNeds < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_expenses_neds, :calculated_valor_final, :decimal
    add_column :integration_expenses_neds, :calculated_valor_pago_final, :decimal
    add_column :integration_expenses_neds, :calculated_valor_suplementado, :decimal
    add_column :integration_expenses_neds, :calculated_valor_pago_suplementado, :decimal
    add_column :integration_expenses_neds, :calculated_valor_anulado, :decimal
    add_column :integration_expenses_neds, :calculated_valor_pago_anulado, :decimal

    add_index :integration_expenses_neds, :natureza, name: :ieneds_natureza
  end
end
