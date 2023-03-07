class CreateIntegrationPurchasesPurchases < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_purchases_purchases do |t|
      t.string :numero_publicacao
      t.string :numero_viproc
      t.string :num_termo_participacao
      t.string :cnpj
      t.string :nome_resp_compra
      t.string :uf_resp_compra
      t.string :macro_regiao_org
      t.string :micro_regiao_org
      t.string :municipio_resp_compra
      t.string :cpf_cnpj_fornecedor
      t.string :nome_fornecedor
      t.string :tipo_fornecedor
      t.string :uf_fornecedor
      t.string :macro_regiao_fornecedor
      t.string :micro_regiao_fornecedor
      t.string :municipio_fornecedor
      t.string :tipo_material_servico
      t.string :nome_grupo
      t.string :codigo_item
      t.string :descricao_item
      t.string :unidade_fornecimento
      t.string :marca
      t.string :natureza_aquisicao
      t.string :tipo_aquisicao
      t.string :sistematica_aquisicao
      t.string :forma_aquisicao
      t.boolean :tratamento_diferenciado
      t.datetime :data_publicacao
      t.decimal :quantidade_estimada
      t.decimal :valor_unitario
      t.datetime :data_finalizada
      t.decimal :valor_total_melhor_lance
      t.decimal :valor_estimado
      t.decimal :valor_total_estimado
      t.boolean :aquisicao_contrato
      t.string :prazo_entrega
      t.string :prazo_pagamento
      t.string :exige_amostras
      t.datetime :data_carga
      t.string :ano
      t.string :mes
      t.string :ano_mes
      t.string :codigo_classe_material
      t.string :nome_classe_material
      t.string :registro_preco
      t.string :unid_compra_regiao_planej
      t.string :fornecedor_regiao_planejamento
      t.string :unidade_gestora
      t.string :grupo_lote
      t.string :descricao_item_referencia
      t.integer :id_item_aquisicao
      t.string :cod_item_referencia

      t.timestamps
    end
  end
end
