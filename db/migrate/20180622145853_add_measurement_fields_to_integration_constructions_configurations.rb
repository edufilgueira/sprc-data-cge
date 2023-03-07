class AddMeasurementFieldsToIntegrationConstructionsConfigurations < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_constructions_configurations, :der_measurement_operation, :string
    add_column :integration_constructions_configurations, :der_measurement_response_path, :string
  end
end
