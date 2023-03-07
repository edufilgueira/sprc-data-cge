class AddIntegrationSupportsOrganIdToIntegrationRevenuesRevenues < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_revenues_revenues, :integration_supports_organ_id, :integer
    add_index :integration_revenues_revenues, :integration_supports_organ_id, name: :irr_organ_id
  end
end
