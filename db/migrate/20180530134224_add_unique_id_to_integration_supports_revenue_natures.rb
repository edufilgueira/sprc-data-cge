class AddUniqueIdToIntegrationSupportsRevenueNatures < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_supports_revenue_natures, :unique_id, :string
    add_index :integration_supports_revenue_natures, :unique_id, name: :isrn_unique_id
  end
end
