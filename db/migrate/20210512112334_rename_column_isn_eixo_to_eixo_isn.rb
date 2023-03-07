class RenameColumnIsnEixoToEixoIsn < ActiveRecord::Migration[5.0]
  def change
  	rename_column :integration_ppa_source_axis_theme_objective_strategies, :isn_eixo, :eixo_isn

  	remove_index :integration_ppa_source_axis_theme_objective_strategies, name: 'int_ppa_sourc_axis_theme_object_strat_isn_eixo'

  	add_index :integration_ppa_source_axis_theme_objective_strategies, [:eixo_isn], name: 'int_ppa_sourc_axis_theme_object_strat_on_eixo_isn'
  end
end
