class AddAttributesAndIndexesToIntegrationConstructionsDaes < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_constructions_daes, :dae_status, :integer
  end
end
