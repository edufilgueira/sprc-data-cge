class RemoveUnusedColumnsFromAndCreateIndexesForNeds < ActiveRecord::Migration[5.0]
  def change
    remove_column :integration_expenses_neds, :integration_expenses_npf_id, :integer
    remove_column :integration_expenses_neds, :management_unit_id, :integer
    remove_column :integration_expenses_neds, :executing_unit_id, :integer
    remove_column :integration_expenses_neds, :creditor_id, :integer

    add_index :integration_expenses_neds, :exercicio, name: :ieneds_exercicio
    add_index :integration_expenses_neds, :unidade_gestora, name: :ieneds_unidade_gestora
    add_index :integration_expenses_neds, :unidade_executora, name: :ieneds_unidade_executora
    add_index :integration_expenses_neds, :numero, name: :ieneds_numero
    add_index :integration_expenses_neds, :numero_ned_ordinaria, name: :ieneds_numero_ned_ordinaria
    add_index :integration_expenses_neds, :numero_npf_ordinario, name: :ieneds_numero_npf_ordinario
    add_index :integration_expenses_neds, :credor, name: :ieneds_credor
    add_index :integration_expenses_neds, :projeto, name: :ieneds_projeto
    add_index :integration_expenses_neds, :numero_contrato, name: :ieneds_numero_contrato
    add_index :integration_expenses_neds, :numero_convenio, name: :ieneds_numero_convenio
  end
end
