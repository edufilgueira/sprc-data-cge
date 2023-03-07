class Integration::Expenses::Daily::SpreadsheetPresenter

  COLUMNS = [
    :exercicio,
    :numero,
    :date_of_issue,
    :management_unit_title,
    :executing_unit_title,
    :creditor_nome,
    :calculated_valor_final
  ]

  attr_reader :daily

  def initialize(daily)
    @daily = daily
  end

  def self.spreadsheet_header
    columns.map do |column|
      spreadsheet_header_title(column)
    end
  end

  def spreadsheet_row
    columns.map do |column|
      if (self.respond_to?(column))
        self.send(column)
      else
        daily.send(column)
      end
    end
  end

  def date_of_issue
    I18n.l(daily.date_of_issue)
  end


  private

  def self.spreadsheet_header_title(column)
    I18n.t("integration/expenses/daily.spreadsheet.worksheets.default.header.#{column}")
  end

  def self.columns
    self::COLUMNS
  end

  def columns
    self.class.columns
  end
end
