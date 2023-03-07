class RenameColumnTemaIdToIsnTema < ActiveRecord::Migration[5.0]
  def change
  	rename_column :integration_ppa_source_axis_theme_objective_strategies, :tema_id, :isn_tema

  	add_index :integration_ppa_source_axis_theme_objective_strategies, [:isn_tema], name: 'int_ppa_sourc_axis_theme_object_strat_isn_tema' 
  end
end
