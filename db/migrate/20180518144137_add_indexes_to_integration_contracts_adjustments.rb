class AddIndexesToIntegrationContractsAdjustments < ActiveRecord::Migration[5.0]
  def change

    add_index :integration_contracts_adjustments, :data_ajuste, name: :icadj_data_ajuste
    add_index :integration_contracts_adjustments, :data_alteracao, name: :icadj_data_alteracao
    add_index :integration_contracts_adjustments, :data_exclusao, name: :icadj_data_exclusao
    add_index :integration_contracts_adjustments, :data_inclusao, name: :icadj_data_inclusao
    add_index :integration_contracts_adjustments, :data_inicio, name: :icadj_data_inicio
    add_index :integration_contracts_adjustments, :data_termino, name: :icadj_data_termino
    add_index :integration_contracts_adjustments, :flg_acrescimo_reducao, name: :icadj_flg_acrescimo_reducao
    add_index :integration_contracts_adjustments, :flg_controle_transmissao, name: :icadj_flg_controle_transmissao
    add_index :integration_contracts_adjustments, :flg_receita_despesa, name: :icadj_flg_receita_despesa
    add_index :integration_contracts_adjustments, :flg_tipo_ajuste, name: :icadj_flg_tipo_ajuste
    add_index :integration_contracts_adjustments, :isn_contrato_ajuste, name: :icadj_isn_contrato_ajuste
    add_index :integration_contracts_adjustments, :isn_contrato_tipo_ajuste, name: :icadj_isn_contrato_tipo_ajuste
    add_index :integration_contracts_adjustments, :ins_edital, name: :icadj_ins_edital
    add_index :integration_contracts_adjustments, :isn_sic, name: :icadj_isn_sic
    add_index :integration_contracts_adjustments, :isn_situacao, name: :icadj_isn_situacao
    add_index :integration_contracts_adjustments, :isn_usuario_alteracao, name: :icadj_isn_usuario_alteracao
    add_index :integration_contracts_adjustments, :isn_usuario_aprovacao, name: :icadj_isn_usuario_aprovacao
    add_index :integration_contracts_adjustments, :isn_usuario_auditoria, name: :icadj_isn_usuario_auditoria
    add_index :integration_contracts_adjustments, :isn_usuario_exclusao, name: :icadj_isn_usuario_exclusao
    add_index :integration_contracts_adjustments, :num_apostilamento_siconv, name: :icadj_num_apostilamento_siconv

  end
end
