class AddOrgansToIntegrationPurchasesPurchases < ActiveRecord::Migration[5.0]
  def change
    add_reference(:integration_purchases_purchases, :manager, foreign_key: { to_table: :integration_supports_organs })
  end
end
