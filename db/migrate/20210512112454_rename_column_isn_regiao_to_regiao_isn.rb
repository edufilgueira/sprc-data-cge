class RenameColumnIsnRegiaoToRegiaoIsn < ActiveRecord::Migration[5.0]
  def change
  	rename_column :integration_ppa_source_axis_theme_objective_strategies, :isn_regiao, :regiao_isn

  	add_index :integration_ppa_source_axis_theme_objective_strategies, [:regiao_isn], name: 'int_ppa_sourc_axis_theme_object_strat_on_regiao_isn'
  end
end
