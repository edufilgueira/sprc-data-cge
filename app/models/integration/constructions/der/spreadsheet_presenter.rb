class Integration::Constructions::Der::SpreadsheetPresenter

  COLUMNS = [
    :base,
    :cerca,
    :conclusao,
    :construtora,
    :cor_status,
    :data_fim_contrato,
    :data_fim_previsto,
    :distrito,
    :drenagem,
    :extensao,
    :id_obra,
    :numero_contrato_der,
    :numero_contrato_ext,
    :numero_contrato_sic,
    :obra_darte,
    :percentual_executado,
    :programa,
    :qtd_empregos,
    :qtd_geo_referencias,
    :revestimento,
    :rodovia,
    :servicos,
    :sinalizacao,
    :status,
    :supervisora,
    :terraplanagem,
    :trecho,
    :ult_atual,
    :valor_aprovado,
    :data_inicio_obra,
    :data_ordem_servico,
    :dias_adicionado,
    :dias_suspenso,
    :municipio,
    :numero_ordem_servico,
    :prazo_inicial,
    :total_aditivo,
    :total_reajuste,
    :valor_atual,
    :valor_original,
    :valor_pi
  ]

  attr_reader :der

  def initialize(der)
    @der = der
  end

  def self.spreadsheet_header
    columns.map do |column|
      spreadsheet_header_title(column)
    end
  end

  def spreadsheet_row
    columns.map do |column|
      der.send(column).to_s
    end
  end

  private

  def self.spreadsheet_header_title(column)
    Integration::Constructions::Der.human_attribute_name(column)
  end

  def self.columns
    COLUMNS
  end

  def columns
    self.class.columns
  end
end
