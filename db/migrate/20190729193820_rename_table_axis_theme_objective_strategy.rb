class RenameTableAxisThemeObjectiveStrategy < ActiveRecord::Migration[5.0]
  def change
    rename_table :integration_ppa_source_axis_theme_objective_strategy, :integration_ppa_source_axis_theme_objective_strategies
  end
end
