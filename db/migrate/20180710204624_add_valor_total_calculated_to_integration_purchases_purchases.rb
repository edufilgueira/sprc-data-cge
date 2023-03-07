class AddValorTotalCalculatedToIntegrationPurchasesPurchases < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_purchases_purchases, :valor_total_calculated, :decimal
  end
end
