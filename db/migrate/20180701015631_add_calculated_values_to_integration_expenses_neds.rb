class AddCalculatedValuesToIntegrationExpensesNeds < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_expenses_neds, :calculated_valor_liquidado_exercicio, :decimal
    add_column :integration_expenses_neds, :calculated_valor_liquidado_apos_exercicio, :decimal
    add_column :integration_expenses_neds, :calculated_valor_pago_exercicio, :decimal
    add_column :integration_expenses_neds, :calculated_valor_pago_apos_exercicio, :decimal
  end
end
