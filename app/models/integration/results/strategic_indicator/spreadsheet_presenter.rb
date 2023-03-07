class Integration::Results::StrategicIndicator::SpreadsheetPresenter

  COLUMNS = [
    :axis_title,
    :resultado,
    :indicador,
    :unidade,
    :sigla_orgao,
    :orgao,
    :valores_realizados,
    :valores_atuais
  ].freeze

  attr_reader :strategic_indicator

  def initialize(strategic_indicator)
    @strategic_indicator = strategic_indicator
  end

  def self.spreadsheet_header
    columns.map do |column|
      spreadsheet_header_title(column)
    end
  end

  def spreadsheet_row
    columns.map do |column|
      strategic_indicator.send(column).to_s
    end
  end


  # privates

  private

  def self.spreadsheet_header_title(column)
    Integration::Results::StrategicIndicator.human_attribute_name(column)
  end

  def self.columns
    COLUMNS
  end

  def columns
    self.class.columns
  end
end
