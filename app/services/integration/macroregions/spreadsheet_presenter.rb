class Integration::Macroregions::SpreadsheetPresenter
  COLUMNS = [
    :ano_exercicio,
    :codigo_poder,
    :descricao_poder,
    :codigo_regiao,
    :descricao_regiao,
    :valor_lei,
    :valor_lei_creditos,
    :valor_empenhado,
    :valor_pago,
    :perc_empenho,
    :perc_pago_calculated
  ].freeze

  attr_reader :investment

  def initialize(investment)
    @investment = investment
  end

  def self.spreadsheet_header
    columns.map do |column|
      spreadsheet_header_title(column)
    end
  end

  def spreadsheet_row
    columns.map do |column|
      investment.send(column).to_s
    end
  end

  private

  def self.spreadsheet_header_title(column)
    Integration::Macroregions::MacroregionInvestiment.human_attribute_name(column)
  end

  def self.columns
    COLUMNS
  end

  def columns
    self.class.columns
  end
end
