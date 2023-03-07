class AddIndexToIntegrationPurchasesPurchase < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_purchases_purchases, :numero_publicacao
    add_index :integration_purchases_purchases, :numero_viproc
    add_index :integration_purchases_purchases, :num_termo_participacao
    add_index :integration_purchases_purchases, :codigo_item
    add_index :integration_purchases_purchases, :data_publicacao
    add_index :integration_purchases_purchases, :data_finalizada
    add_index :integration_purchases_purchases, :descricao_item
    add_index :integration_purchases_purchases, :nome_fornecedor
    add_index :integration_purchases_purchases, :nome_resp_compra
    add_index :integration_purchases_purchases, :natureza_aquisicao
    add_index :integration_purchases_purchases, :nome_grupo
  end
end
