class RemoveUnusedColumnsFromAndCreateIndexesForNpds < ActiveRecord::Migration[5.0]
  def change
    remove_column :integration_expenses_npds, :integration_expenses_nld_id, :integer
    remove_column :integration_expenses_npds, :management_unit_id, :integer
    remove_column :integration_expenses_npds, :executing_unit_id, :integer
    remove_column :integration_expenses_npds, :creditor_id, :integer

    add_index :integration_expenses_npds, :exercicio, name: :ienpds_exercicio
    add_index :integration_expenses_npds, :unidade_gestora, name: :ienpds_unidade_gestora
    add_index :integration_expenses_npds, :unidade_executora, name: :ienpds_unidade_executora
    add_index :integration_expenses_npds, :numero, name: :ienpds_numero
    add_index :integration_expenses_npds, :numero_npd_ordinaria, name: :ienpds_numero_npd_ordinaria
    add_index :integration_expenses_npds, :numero_nld_ordinaria, name: :ienpds_numero_npf_ordinaria
    add_index :integration_expenses_npds, :credor, name: :ienpds_credor

  end
end
