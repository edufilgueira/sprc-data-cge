class RenameColumnEixoIdToIsnEixo < ActiveRecord::Migration[5.0]
  def change
  	rename_column :integration_ppa_source_axis_theme_objective_strategies, :eixo_id, :isn_eixo

  	add_index :integration_ppa_source_axis_theme_objective_strategies, [:isn_eixo], name: 'int_ppa_sourc_axis_theme_object_strat_isn_eixo'
  end
end
