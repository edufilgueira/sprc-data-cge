class AddNameToIntegrationSupportsOrgans < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_supports_organs, :name, :string
  end
end
