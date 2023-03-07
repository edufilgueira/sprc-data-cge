class RenameColumnIsnTemaToTemaIsn < ActiveRecord::Migration[5.0]
  def change
  	rename_column :integration_ppa_source_axis_theme_objective_strategies, :isn_tema, :tema_isn
  	
  	remove_index :integration_ppa_source_axis_theme_objective_strategies, name: 'int_ppa_sourc_axis_theme_object_strat_isn_tema'

  	add_index :integration_ppa_source_axis_theme_objective_strategies, [:tema_isn], name: 'int_ppa_sourc_axis_theme_object_strat_on_tema_isn'

  end
end
