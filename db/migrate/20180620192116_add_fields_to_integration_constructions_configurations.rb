class AddFieldsToIntegrationConstructionsConfigurations < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_constructions_configurations, :der_contract_operation, :string
    add_column :integration_constructions_configurations, :der_contract_response_path, :string
  end
end
