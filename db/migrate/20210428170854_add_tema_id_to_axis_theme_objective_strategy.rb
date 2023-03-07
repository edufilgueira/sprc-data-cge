class AddTemaIdToAxisThemeObjectiveStrategy < ActiveRecord::Migration[5.0]
  def change
  	add_column :integration_ppa_source_axis_theme_objective_strategies, :tema_id, :integer
  end
end
