class AddDerCoordinatesToIntegrationConstructionsConfigurations < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_constructions_configurations, :der_coordinates_operation, :string
    add_column :integration_constructions_configurations, :der_coordinates_response_path, :string
  end
end
