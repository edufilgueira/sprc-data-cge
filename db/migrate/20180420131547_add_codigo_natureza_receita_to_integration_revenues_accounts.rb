class AddCodigoNaturezaReceitaToIntegrationRevenuesAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_revenues_accounts, :codigo_natureza_receita, :string
    add_index :integration_revenues_accounts, :codigo_natureza_receita, name: :ira_codigo_natureza_receita
  end
end
