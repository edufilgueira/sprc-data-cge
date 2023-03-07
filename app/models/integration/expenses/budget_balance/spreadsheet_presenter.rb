class Integration::Expenses::BudgetBalance::SpreadsheetPresenter

  COLUMNS = [
    :year,
    :month,
    :secretary_title,
    :organ_title,

    :function_title,
    :sub_function_title,
    :government_program_title,
    :government_action_title,
    :administrative_region_title,
    :expense_nature_title,
    :qualified_resource_source_title,
    :finance_group_title,

    :calculated_valor_orcamento_inicial,
    :calculated_valor_orcamento_atualizado,
    :calculated_valor_empenhado,
    :calculated_valor_liquidado,
    :calculated_valor_pago
  ]

  attr_reader :budget_balance

  def initialize(budget_balance)
    @budget_balance = budget_balance
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
        budget_balance.send(column)
      end
    end
  end

  private

  def self.spreadsheet_header_title(column)
    I18n.t("integration/expenses/budget_balance.spreadsheet.worksheets.default.header.#{column}")
  end

  def self.columns
    self::COLUMNS
  end

  def columns
    self.class.columns
  end
end
