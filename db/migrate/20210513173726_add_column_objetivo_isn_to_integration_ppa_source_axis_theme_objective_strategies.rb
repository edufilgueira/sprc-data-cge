class AddColumnObjetivoIsnToIntegrationPPASourceAxisThemeObjectiveStrategies < ActiveRecord::Migration[5.0]
  def change
  	add_column :integration_ppa_source_axis_theme_objective_strategies, :objetivo_isn, :integer

  	add_index :integration_ppa_source_axis_theme_objective_strategies, [:objetivo_isn], name: 'int_ppa_sourc_axis_theme_object_strat_on_objetivo_isn'
  end
end
