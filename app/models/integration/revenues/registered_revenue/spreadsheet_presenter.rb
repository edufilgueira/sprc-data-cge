class Integration::Revenues::RegisteredRevenue::SpreadsheetPresenter

  COLUMNS = [
    :year,
    :month,
    :unidade,
    :poder,
    :administracao,
    :conta_contabil,
    :titulo,
    :natureza_da_conta,
    :natureza_credito,
    :valor_credito,
    :natureza_debito,
    :valor_debito,
    :valor_inicial,
    :natureza_inicial
  ]

  attr_reader :registered_revenue

  def initialize(registered_revenue)
    @registered_revenue = registered_revenue
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
        registered_revenue.send(column)
      end
    end
  end

  # Override

  def year
    registered_revenue.year
  end

  def month
    registered_revenue.month
  end

  def unidade
    registered_revenue.organ.present? ? registered_revenue.organ.title : '-'
  end

  def poder
    registered_revenue.poder
  end

  def administracao
    registered_revenue.administracao
  end

  def conta_contabil
    registered_revenue.conta_contabil
  end

  def titulo
    registered_revenue.titulo
  end

  def natureza_da_conta
    registered_revenue.natureza_da_conta
  end

  private

  def self.spreadsheet_header_title(column)
    I18n.t("integration/revenues/registered_revenue.spreadsheet.worksheets.default.header.#{column}")
  end

  def self.columns
    self::COLUMNS
  end

  def columns
    self.class.columns
  end
end
