class AddIndexesToIntegrationExpensesNpds < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_expenses_npds, :servico_bancario, name: :ienpds_servico_bancario
    add_index :integration_expenses_npds, :natureza, name: :ienpds_natureza
  end
end
