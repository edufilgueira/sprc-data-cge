class AddAssociationsToIntegrationExpensesBudgetBalances < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_expenses_budget_balances, :cod_categoria_economica, :string
    add_index :integration_expenses_budget_balances, :cod_categoria_economica, name: :iebb_cod_categoria_economica
    add_column :integration_expenses_budget_balances, :cod_modalidade_aplicacao, :string
    add_index :integration_expenses_budget_balances, :cod_modalidade_aplicacao, name: :iebb_cod_modalidade_aplicacao
    add_column :integration_expenses_budget_balances, :cod_elemento_despesa, :string
    add_index :integration_expenses_budget_balances, :cod_elemento_despesa, name: :iebb_cod_elemento_despesa
  end
end
