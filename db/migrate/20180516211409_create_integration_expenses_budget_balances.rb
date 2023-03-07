class CreateIntegrationExpensesBudgetBalances < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_expenses_budget_balances do |t|
      t.string :data_atual
      t.string :ano_mes_competencia
      t.string :cod_unid_gestora
      t.string :cod_unid_orcam
      t.string :cod_funcao
      t.string :cod_subfuncao
      t.string :cod_programa
      t.string :cod_acao
      t.string :cod_localizacao_gasto
      t.string :cod_natureza_desp
      t.string :cod_fonte
      t.string :id_uso
      t.string :cod_grupo_desp
      t.string :cod_tp_orcam
      t.string :cod_esfera_orcam
      t.string :cod_grupo_fin
      t.string :classif_orcam_reduz
      t.string :classif_orcam_completa
      t.decimal :valor_inicial
      t.decimal :valor_suplementado
      t.decimal :valor_anulado
      t.decimal :valor_transferido_recebido
      t.decimal :valor_transferido_concedido
      t.decimal :valor_contido
      t.decimal :valor_contido_anulado
      t.decimal :valor_descentralizado
      t.decimal :valor_descentralizado_anulado
      t.decimal :valor_empenhado
      t.decimal :valor_empenhado_anulado
      t.decimal :valor_liquidado
      t.decimal :valor_liquidado_anulado
      t.decimal :valor_liquidado_retido
      t.decimal :valor_liquidado_retido_anulado
      t.decimal :valor_pago
      t.decimal :valor_pago_anulado
      t.decimal :calculated_valor_orcamento_inicial
      t.decimal :calculated_valor_orcamento_atualizado
      t.decimal :calculated_valor_empenhado
      t.decimal :calculated_valor_liquidado
      t.decimal :calculated_valor_pago

      t.timestamps
    end
    add_index :integration_expenses_budget_balances, :ano_mes_competencia, name: :iebb_ano_mes_competencia
    add_index :integration_expenses_budget_balances, :cod_unid_gestora, name: :iebb_cod_unid_gestora
    add_index :integration_expenses_budget_balances, :cod_unid_orcam, name: :iebb_cod_unid_orcam
    add_index :integration_expenses_budget_balances, :cod_funcao, name: :iebb_cod_funcao
    add_index :integration_expenses_budget_balances, :cod_subfuncao, name: :iebb_cod_subfuncao
    add_index :integration_expenses_budget_balances, :cod_programa, name: :iebb_cod_programa
    add_index :integration_expenses_budget_balances, :cod_acao, name: :iebb_cod_acao
    add_index :integration_expenses_budget_balances, :cod_localizacao_gasto, name: :iebb_cod_localizacao_gasto
    add_index :integration_expenses_budget_balances, :cod_natureza_desp, name: :iebb_cod_natureza_desp
    add_index :integration_expenses_budget_balances, :cod_fonte, name: :iebb_cod_fonte
    add_index :integration_expenses_budget_balances, :id_uso, name: :iebb_id_uso
    add_index :integration_expenses_budget_balances, :cod_grupo_desp, name: :iebb_cod_grupo_desp
    add_index :integration_expenses_budget_balances, :cod_tp_orcam, name: :iebb_cod_tp_orcam
    add_index :integration_expenses_budget_balances, :cod_esfera_orcam, name: :iebb_cod_esfera_orcam
    add_index :integration_expenses_budget_balances, :cod_grupo_fin, name: :iebb_cod_grupo_fin
    add_index :integration_expenses_budget_balances, :classif_orcam_completa, name: :iebb_classif_orcam_completa
  end
end
