class AddYearToIntegrationSupportsRevenueNature < ActiveRecord::Migration[5.0]
  def change
  	add_column :integration_supports_revenue_natures, :year, :integer
  end
end
