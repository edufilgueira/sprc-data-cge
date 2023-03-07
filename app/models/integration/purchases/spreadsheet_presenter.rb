class Integration::Purchases::SpreadsheetPresenter

  COLUMNS = [
    :numero_publicacao,
    :numero_viproc,
    :num_termo_participacao,
    :cnpj,
    :nome_resp_compra,
    :uf_resp_compra,
    :macro_regiao_org,
    :micro_regiao_org,
    :municipio_resp_compra,
    :cpf_cnpj_fornecedor,
    :nome_fornecedor,
    :tipo_fornecedor,
    :uf_fornecedor,
    :macro_regiao_fornecedor,
    :micro_regiao_fornecedor,
    :municipio_fornecedor,
    :tipo_material_servico,
    :nome_grupo,
    :codigo_item,
    :descricao_item,
    :unidade_fornecimento,
    :marca,
    :natureza_aquisicao,
    :tipo_aquisicao,
    :sistematica_aquisicao,
    :forma_aquisicao,
    :tratamento_diferenciado ,
    :data_publicacao,
    :quantidade_estimada,
    :valor_unitario,
    :data_finalizada,
    :valor_total_melhor_lance,
    :valor_estimado,
    :valor_total_estimado,
    :aquisicao_contrato ,
    :prazo_entrega,
    :prazo_pagamento,
    :exige_amostras,
    :data_carga,
    :ano,
    :mes,
    :ano_mes,
    :codigo_classe_material,
    :nome_classe_material,
    :registro_preco,
    :unid_compra_regiao_planej,
    :fornecedor_regiao_planejamento,
    :unidade_gestora,
    :grupo_lote,
    :descricao_item_referencia,
    :id_item_aquisicao,
    :cod_item_referencia,
    :valor_total_calculated
  ].freeze

  attr_reader :purchase

  def initialize(purchase)
    @purchase = purchase
  end

  def self.spreadsheet_header
    columns.map do |column|
      spreadsheet_header_title(column)
    end
  end

  def spreadsheet_row
    columns.map do |column|
      purchase.send(column).to_s
    end
  end

  private

  def self.spreadsheet_header_title(column)
    Integration::Purchases::Purchase.human_attribute_name(column)
  end

  def self.columns
    COLUMNS
  end

  def columns
    self.class.columns
  end
end
