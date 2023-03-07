class AddRevenueNatureTypeToIntegrationSupportsRevenueNatures < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_supports_revenue_natures, :revenue_nature_type, :integer
    add_index :integration_supports_revenue_natures, :revenue_nature_type, name: :isrn_revenue_nature_type
  end
end
