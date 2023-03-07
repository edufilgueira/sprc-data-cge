class AddIntegrationSupportsSecretaryIdToIntegrationRevenuesRevenues < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_revenues_revenues, :integration_supports_secretary_id, :integer
    add_index :integration_revenues_revenues, :integration_supports_secretary_id, name: :irr_secretary_id
  end
end
