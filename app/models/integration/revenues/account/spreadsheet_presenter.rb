class Integration::Revenues::Account::SpreadsheetPresenter

  COLUMNS = [
    :year,
    :month,
    :unidade,
    :poder,
    :administracao,
    :conta_contabil,
    :titulo,
    :natureza_da_conta,
    :conta_corrente,
    :natureza_credito,
    :valor_credito,
    :natureza_debito,
    :valor_debito,
    :valor_inicial,
    :natureza_inicial,
    :codigo_natureza_receita,
    :natureza_receita
  ]

  attr_reader :account, :revenue, :revenue_nature

  def initialize(account)
    @account = account
    @revenue = account.revenue
    @revenue_nature = account.revenue_nature
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
        account.send(column)
      end
    end
  end

  # Override

  def year
    revenue.year
  end

  def month
    revenue.month
  end

  def unidade
    revenue.organ.present? ? revenue.organ.title : '-'
  end

  def poder
    revenue.poder
  end

  def administracao
    revenue.administracao
  end

  def conta_contabil
    revenue.conta_contabil
  end

  def titulo
    revenue.titulo
  end

  def natureza_da_conta
    revenue.natureza_da_conta
  end

  def natureza_receita
    revenue_nature.descricao
  end

  private

  def self.spreadsheet_header_title(column)
    I18n.t("integration/revenues/account.spreadsheet.worksheets.default.header.#{column}")
  end

  def self.columns
    self::COLUMNS
  end

  def columns
    self.class.columns
  end
end
