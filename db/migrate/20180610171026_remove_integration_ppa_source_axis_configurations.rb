class RemoveIntegrationPPASourceAxisConfigurations < ActiveRecord::Migration[5.0]
  def change
    # Dado foi remodelado para :integration_ppa_source_axis_theme_configurations
    drop_table :integration_ppa_source_axis_configurations
  end
end
