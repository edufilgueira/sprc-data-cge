class AddOrganSfpToIntegrationSupportsOrgans < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_supports_organs, :orgao_sfp, :boolean
    add_index :integration_supports_organs, :orgao_sfp
  end
end
