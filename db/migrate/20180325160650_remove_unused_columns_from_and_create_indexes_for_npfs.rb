class RemoveUnusedColumnsFromAndCreateIndexesForNpfs < ActiveRecord::Migration[5.0]
  def change
    remove_column :integration_expenses_npfs, :management_unit_id, :integer
    remove_column :integration_expenses_npfs, :executing_unit_id, :integer
    remove_column :integration_expenses_npfs, :creditor_id, :integer

    add_index :integration_expenses_npfs, :exercicio, name: :ienpfs_exercicio
    add_index :integration_expenses_npfs, :unidade_gestora, name: :ienpfs_unidade_gestora
    add_index :integration_expenses_npfs, :unidade_executora, name: :ienpfs_unidade_executora
    add_index :integration_expenses_npfs, :numero, name: :ienpfs_numero
    add_index :integration_expenses_npfs, :numero_npf_ord, name: :ienpfs_numero_npf_ord
    add_index :integration_expenses_npfs, :credor, name: :ienpfs_credor

  end
end
