class AddClassificacaoElementoDespesaToIntegrationExpensesNeds < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_expenses_neds, :classificacao_elemento_despesa, :string
    add_index :integration_expenses_neds, :classificacao_elemento_despesa, name: :ien_c_elemento_despesa
  end
end
