class Integration::Expenses::Ned::SpreadsheetPresenter

  COLUMNS = [
    :exercicio,
    :numero,
    :date_of_issue,
    :management_unit_title,
    :executing_unit_title,
    :budget_unit_title,
    :creditor_nome,

    :function_title,
    :sub_function_title,
    :government_program_title,
    :government_action_title,
    :administrative_region_title,
    :expense_nature_title,
    :resource_source_title,
    :expense_type_title,

    :valor,
    :valor_pago,

    :calculated_valor_final,
    :calculated_valor_pago_final,
    :calculated_valor_suplementado,
    :calculated_valor_anulado,
    :calculated_valor_pago_anulado
  ]

  attr_reader :ned

  def initialize(ned)
    @ned = ned
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
        ned.send(column)
      end
    end
  end

  def date_of_issue
    I18n.l(ned.date_of_issue)
  end

  private

  def self.spreadsheet_header_title(column)
    I18n.t("integration/expenses/ned.spreadsheet.worksheets.default.header.#{column}")
  end

  def self.columns
    self::COLUMNS
  end

  def columns
    self.class.columns
  end
end
