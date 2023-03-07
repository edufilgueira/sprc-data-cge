class AddCodeAndAcronymToIntegrationSupportsOrgans < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_supports_organs, :code, :string
    add_index :integration_supports_organs, :code
    add_column :integration_supports_organs, :acronym, :string
    add_index :integration_supports_organs, :acronym
  end
end
