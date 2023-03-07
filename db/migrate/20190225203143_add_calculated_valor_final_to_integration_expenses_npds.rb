class AddCalculatedValorFinalToIntegrationExpensesNpds < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_expenses_npds, :calculated_valor_final, :decimal
  end
end
