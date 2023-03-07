class AddConsolidatedToIntegrationOutsourcingMNonthlyCostsConfiguration < ActiveRecord::Migration[5.0]
  def change
  	add_column :integration_outsourcing_configurations, :consolidation_operation, :string
  	add_column :integration_outsourcing_configurations, :consolidation_response_path, :string
  end
end
