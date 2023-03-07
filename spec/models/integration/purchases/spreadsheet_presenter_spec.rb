require 'rails_helper'

describe Integration::Purchases::SpreadsheetPresenter do

  subject(:purchase_spreadsheet_presenter) do
    Integration::Purchases::SpreadsheetPresenter.new(purchase)
  end

  let(:purchase) { create(:integration_purchases_purchase) }

  let(:klass) { Integration::Purchases::Purchase }

  it 'spreadsheet_header' do
    expected = [
      klass.human_attribute_name(:numero_publicacao),
      klass.human_attribute_name(:numero_viproc),
      klass.human_attribute_name(:num_termo_participacao),
      klass.human_attribute_name(:cnpj),
      klass.human_attribute_name(:nome_resp_compra),
      klass.human_attribute_name(:uf_resp_compra),
      klass.human_attribute_name(:macro_regiao_org),
      klass.human_attribute_name(:micro_regiao_org),
      klass.human_attribute_name(:municipio_resp_compra),
      klass.human_attribute_name(:cpf_cnpj_fornecedor),
      klass.human_attribute_name(:nome_fornecedor),
      klass.human_attribute_name(:tipo_fornecedor),
      klass.human_attribute_name(:uf_fornecedor),
      klass.human_attribute_name(:macro_regiao_fornecedor),
      klass.human_attribute_name(:micro_regiao_fornecedor),
      klass.human_attribute_name(:municipio_fornecedor),
      klass.human_attribute_name(:tipo_material_servico),
      klass.human_attribute_name(:nome_grupo),
      klass.human_attribute_name(:codigo_item),
      klass.human_attribute_name(:descricao_item),
      klass.human_attribute_name(:unidade_fornecimento),
      klass.human_attribute_name(:marca),
      klass.human_attribute_name(:natureza_aquisicao),
      klass.human_attribute_name(:tipo_aquisicao),
      klass.human_attribute_name(:sistematica_aquisicao),
      klass.human_attribute_name(:forma_aquisicao),
      klass.human_attribute_name(:tratamento_diferenciado ),
      klass.human_attribute_name(:data_publicacao),
      klass.human_attribute_name(:quantidade_estimada),
      klass.human_attribute_name(:valor_unitario),
      klass.human_attribute_name(:data_finalizada),
      klass.human_attribute_name(:valor_total_melhor_lance),
      klass.human_attribute_name(:valor_estimado),
      klass.human_attribute_name(:valor_total_estimado),
      klass.human_attribute_name(:aquisicao_contrato ),
      klass.human_attribute_name(:prazo_entrega),
      klass.human_attribute_name(:prazo_pagamento),
      klass.human_attribute_name(:exige_amostras),
      klass.human_attribute_name(:data_carga),
      klass.human_attribute_name(:ano),
      klass.human_attribute_name(:mes),
      klass.human_attribute_name(:ano_mes),
      klass.human_attribute_name(:codigo_classe_material),
      klass.human_attribute_name(:nome_classe_material),
      klass.human_attribute_name(:registro_preco),
      klass.human_attribute_name(:unid_compra_regiao_planej),
      klass.human_attribute_name(:fornecedor_regiao_planejamento),
      klass.human_attribute_name(:unidade_gestora),
      klass.human_attribute_name(:grupo_lote),
      klass.human_attribute_name(:descricao_item_referencia),
      klass.human_attribute_name(:id_item_aquisicao),
      klass.human_attribute_name(:cod_item_referencia),
      klass.human_attribute_name(:valor_total_calculated)
    ]

    expect(Integration::Purchases::SpreadsheetPresenter.spreadsheet_header).to eq(expected)
  end

  it 'spreadsheet_row' do
    expected = [
      purchase.numero_publicacao.to_s,
      purchase.numero_viproc.to_s,
      purchase.num_termo_participacao.to_s,
      purchase.cnpj.to_s,
      purchase.nome_resp_compra.to_s,
      purchase.uf_resp_compra.to_s,
      purchase.macro_regiao_org.to_s,
      purchase.micro_regiao_org.to_s,
      purchase.municipio_resp_compra.to_s,
      purchase.cpf_cnpj_fornecedor.to_s,
      purchase.nome_fornecedor.to_s,
      purchase.tipo_fornecedor.to_s,
      purchase.uf_fornecedor.to_s,
      purchase.macro_regiao_fornecedor.to_s,
      purchase.micro_regiao_fornecedor.to_s,
      purchase.municipio_fornecedor.to_s,
      purchase.tipo_material_servico.to_s,
      purchase.nome_grupo.to_s,
      purchase.codigo_item.to_s,
      purchase.descricao_item.to_s,
      purchase.unidade_fornecimento.to_s,
      purchase.marca.to_s,
      purchase.natureza_aquisicao.to_s,
      purchase.tipo_aquisicao.to_s,
      purchase.sistematica_aquisicao.to_s,
      purchase.forma_aquisicao.to_s,
      purchase.tratamento_diferenciado.to_s,
      purchase.data_publicacao.to_s,
      purchase.quantidade_estimada.to_s,
      purchase.valor_unitario.to_s,
      purchase.data_finalizada.to_s,
      purchase.valor_total_melhor_lance.to_s,
      purchase.valor_estimado.to_s,
      purchase.valor_total_estimado.to_s,
      purchase.aquisicao_contrato.to_s ,
      purchase.prazo_entrega.to_s,
      purchase.prazo_pagamento.to_s,
      purchase.exige_amostras.to_s,
      purchase.data_carga.to_s,
      purchase.ano.to_s,
      purchase.mes.to_s,
      purchase.ano_mes.to_s,
      purchase.codigo_classe_material.to_s,
      purchase.nome_classe_material.to_s,
      purchase.registro_preco.to_s,
      purchase.unid_compra_regiao_planej.to_s,
      purchase.fornecedor_regiao_planejamento.to_s,
      purchase.unidade_gestora.to_s,
      purchase.grupo_lote.to_s,
      purchase.descricao_item_referencia.to_s,
      purchase.id_item_aquisicao.to_s,
      purchase.cod_item_referencia.to_s,
      purchase.valor_total_calculated.to_s
    ]

    result = purchase_spreadsheet_presenter.spreadsheet_row

    expect(result).to eq(expected)
  end
end
