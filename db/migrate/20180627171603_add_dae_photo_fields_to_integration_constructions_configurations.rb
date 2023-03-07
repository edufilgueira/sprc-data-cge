class AddDaePhotoFieldsToIntegrationConstructionsConfigurations < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_constructions_configurations, :dae_photo_operation, :string
    add_column :integration_constructions_configurations, :dae_photo_response_path, :string
  end
end
