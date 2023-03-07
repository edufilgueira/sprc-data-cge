class AddCgeCodeToIntegrationSupportsOrgans < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_supports_organs, :cge_code, :string
    add_index :integration_supports_organs, :cge_code
  end
end
