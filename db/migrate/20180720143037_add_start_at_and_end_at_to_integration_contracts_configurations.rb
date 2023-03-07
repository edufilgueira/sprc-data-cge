class AddStartAtAndEndAtToIntegrationContractsConfigurations < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_contracts_configurations, :start_at, :date
    add_column :integration_contracts_configurations, :end_at, :date
  end
end
