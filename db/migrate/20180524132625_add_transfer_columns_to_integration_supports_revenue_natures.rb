class AddTransferColumnsToIntegrationSupportsRevenueNatures < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_supports_revenue_natures, :transfer_voluntary, :boolean
    add_index :integration_supports_revenue_natures, :transfer_voluntary, name: :isrn_transfer_voluntary
    add_column :integration_supports_revenue_natures, :transfer_required, :boolean
    add_index :integration_supports_revenue_natures, :transfer_required, name: :isrn_transfer_required
  end
end
