class AddIndexYearToRevenuesNatures < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_supports_revenue_natures, :year
  end
end
