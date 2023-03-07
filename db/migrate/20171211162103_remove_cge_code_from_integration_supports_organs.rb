class RemoveCgeCodeFromIntegrationSupportsOrgans < ActiveRecord::Migration[5.0]
  def change
    remove_column :integration_supports_organs, :cge_code, :integer
  end
end
