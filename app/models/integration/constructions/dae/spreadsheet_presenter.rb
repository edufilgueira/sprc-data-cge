class Integration::Constructions::Dae::SpreadsheetPresenter

  COLUMNS = [
    :id_obra,
    :codigo_obra,
    :contratada,
    :data_fim_previsto,
    :data_inicio,
    :data_ordem_servico,
    :descricao,
    :dias_aditivado,
    :latitude,
    :longitude,
    :municipio,
    :numero_licitacao,
    :numero_ordem_servico,
    :numero_sacc,
    :percentual_executado,
    :prazo_inicial,
    :secretaria,
    :status,
    :tipo_contrato,
    :valor
  ]

  attr_reader :dae

  def initialize(dae)
    @dae = dae
  end

  def self.spreadsheet_header
    columns.map do |column|
      spreadsheet_header_title(column)
    end
  end

  def spreadsheet_row
    columns.map do |column|
      dae.send(column).to_s
    end
  end

  private

  def self.spreadsheet_header_title(column)
    Integration::Constructions::Dae.human_attribute_name(column)
  end

  def self.columns
    COLUMNS
  end

  def columns
    self.class.columns
  end
end
