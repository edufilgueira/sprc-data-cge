class ModifyIndexesForPurchases < ActiveRecord::Migration[5.0]
  def change
  	add_index :integration_purchases_purchases, :sistematica_aquisicao
    add_index :integration_purchases_purchases, :forma_aquisicao
    add_index :integration_purchases_purchases, :tipo_aquisicao
  end
end
