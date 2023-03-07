class AddOriginToIntegrationServersProceedType < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_servers_proceed_types, :origin, :integer
  end
end
