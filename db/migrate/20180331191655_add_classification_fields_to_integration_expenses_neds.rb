class AddClassificationFieldsToIntegrationExpensesNeds < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_expenses_neds, :classificacao_unidade_orcamentaria, :string
    add_column :integration_expenses_neds, :classificacao_funcao, :string
    add_column :integration_expenses_neds, :classificacao_subfuncao, :string
    add_column :integration_expenses_neds, :classificacao_programa_governo, :string
    add_column :integration_expenses_neds, :classificacao_acao_governamental, :string
    add_column :integration_expenses_neds, :classificacao_regiao_administrativa, :string
    add_column :integration_expenses_neds, :classificacao_natureza_despesa, :string
    add_column :integration_expenses_neds, :classificacao_cod_destinacao, :string
    add_column :integration_expenses_neds, :classificacao_fonte_recursos, :string
    add_column :integration_expenses_neds, :classificacao_subfonte, :string
    add_column :integration_expenses_neds, :classificacao_id_uso, :string
    add_column :integration_expenses_neds, :classificacao_tipo_despesa, :string

    add_index :integration_expenses_neds, :classificacao_unidade_orcamentaria, name: :iens_classificacao_unidade_orcamentaria
    add_index :integration_expenses_neds, :classificacao_funcao, name: :iens_classificacao_funcao
    add_index :integration_expenses_neds, :classificacao_subfuncao, name: :iens_classificacao_subfuncao
    add_index :integration_expenses_neds, :classificacao_programa_governo, name: :iens_classificacao_programa_governo
    add_index :integration_expenses_neds, :classificacao_acao_governamental, name: :iens_classificacao_acao_governamental
    add_index :integration_expenses_neds, :classificacao_regiao_administrativa, name: :iens_classificacao_regiao_administrativa
    add_index :integration_expenses_neds, :classificacao_natureza_despesa, name: :iens_classificacao_natureza_despesa
    add_index :integration_expenses_neds, :classificacao_cod_destinacao, name: :iens_classificacao_cod_destinacao
    add_index :integration_expenses_neds, :classificacao_fonte_recursos, name: :iens_classificacao_fonte_recursos
    add_index :integration_expenses_neds, :classificacao_subfonte, name: :iens_classificacao_subfonte
    add_index :integration_expenses_neds, :classificacao_id_uso, name: :iens_classificacao_id_uso
    add_index :integration_expenses_neds, :classificacao_tipo_despesa, name: :iens_classificacao_tipo_despesa
  end
end
