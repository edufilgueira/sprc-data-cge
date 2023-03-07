class AddDailyToIntegrationExpensesNpds < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_expenses_npds, :daily, :boolean
    add_index :integration_expenses_npds, :daily, name: :ienpd_daily
  end
end
