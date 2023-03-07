class RemoveColumnCodeAcronymAndNameFromIntegrationSupportsOrgans < ActiveRecord::Migration[5.0]
  def change
    remove_index :integration_supports_organs, :code
    remove_index :integration_supports_organs, :acronym

    remove_column :integration_supports_organs, :code, :string
    remove_column :integration_supports_organs, :acronym, :string
    remove_column :integration_supports_organs, :name, :string
  end
end
