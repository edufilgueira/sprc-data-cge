class RemoveUnusedColumnsFromAndCreateIndexesForNlds < ActiveRecord::Migration[5.0]
  def change
    remove_column :integration_expenses_nlds, :integration_expenses_ned_id, :integer
    remove_column :integration_expenses_nlds, :management_unit_id, :integer
    remove_column :integration_expenses_nlds, :executing_unit_id, :integer
    remove_column :integration_expenses_nlds, :creditor_id, :integer

    add_index :integration_expenses_nlds, :exercicio, name: :ienlds_exercicio
    add_index :integration_expenses_nlds, :unidade_gestora, name: :ienlds_unidade_gestora
    add_index :integration_expenses_nlds, :unidade_executora, name: :ienlds_unidade_executora
    add_index :integration_expenses_nlds, :numero, name: :ienlds_numero
    add_index :integration_expenses_nlds, :numero_nld_ordinaria, name: :ienlds_numero_nld_ordinaria
    add_index :integration_expenses_nlds, :numero_npf_ordinaria, name: :ienlds_numero_npf_ordinaria
    add_index :integration_expenses_nlds, :credor, name: :ienlds_credor
    add_index :integration_expenses_nlds, :numero_nota_empenho_despesa, name: :ienlds_numero_nota_empenho_despesa
    add_index :integration_expenses_nlds, :numero_do_documento_da_despesa, name: :ienlds_numero_do_documento_da_despesa

  end
end
