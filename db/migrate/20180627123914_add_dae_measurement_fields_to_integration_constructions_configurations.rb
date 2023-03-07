class AddDaeMeasurementFieldsToIntegrationConstructionsConfigurations < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_constructions_configurations, :dae_measurement_operation, :string
    add_column :integration_constructions_configurations, :dae_measurement_response_path, :string
  end
end
