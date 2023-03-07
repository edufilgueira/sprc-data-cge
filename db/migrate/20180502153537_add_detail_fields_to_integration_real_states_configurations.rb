class AddDetailFieldsToIntegrationRealStatesConfigurations < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_real_states_configurations, :detail_operation, :string
    add_column :integration_real_states_configurations, :detail_response_path, :string
  end
end
