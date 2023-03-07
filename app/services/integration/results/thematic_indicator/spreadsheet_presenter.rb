class Integration::Results::ThematicIndicator::SpreadsheetPresenter

  COLUMNS = [
    :axis_title,
    :theme_title,
    :resultado,
    :indicador,
    :unidade,
    :sigla_orgao,
    :orgao,
    :valores_realizados,
    :valores_programados
  ].freeze

  attr_reader :thematic_indicator

  def initialize(thematic_indicator)
    @thematic_indicator = thematic_indicator
  end

  def self.spreadsheet_header
    columns.map do |column|
      spreadsheet_header_title(column)
    end
  end

  def spreadsheet_row
    columns.map do |column|
      thematic_indicator.send(column).to_s
    end
  end


  # privates

  private

  def self.spreadsheet_header_title(column)
    Integration::Results::ThematicIndicator.human_attribute_name(column)
  end

  def self.columns
    COLUMNS
  end

  def columns
    self.class.columns
  end
end
