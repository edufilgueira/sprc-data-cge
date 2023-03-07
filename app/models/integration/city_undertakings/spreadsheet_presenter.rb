class Integration::CityUndertakings::SpreadsheetPresenter

  COLUMNS = [
    :municipio,
    :tipo_despesa,
    :sic,
    :mapp,
    :organ_title,
    :creditor_title,
    :undertaking_title,
    :valor_programado1,
    :valor_programado2,
    :valor_programado3,
    :valor_programado4,
    :valor_programado5,
    :valor_programado6,
    :valor_programado7,
    :valor_programado8,
    :valor_executado1,
    :valor_executado2,
    :valor_executado3,
    :valor_executado4,
    :valor_executado5,
    :valor_executado6,
    :valor_executado7,
    :valor_executado8
  ].freeze

  attr_reader :city_undertaking

  def initialize(city_undertaking)
    @city_undertaking = city_undertaking
  end

  def self.spreadsheet_header
    columns.map do |column|
      spreadsheet_header_title(column)
    end
  end

  def spreadsheet_row
    columns.map do |column|
      city_undertaking.send(column).to_s
    end
  end

  private

  def self.spreadsheet_header_title(column)
    Integration::CityUndertakings::CityUndertaking.human_attribute_name(column)
  end

  def self.columns
    COLUMNS
  end

  def columns
    self.class.columns
  end
end
