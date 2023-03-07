class Integration::Contracts::Financials::SpreadsheetPresenter

  COLUMNS = [
    :num_documento,
    :data_documento,
    :valor_documento,
    :num_pagamento,
    :data_pagamento,
    :valor_pagamento
  ].freeze

  attr_reader :financial

  def initialize(financial)
    @financial = financial
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
        financial.send(column)
      end
    end
  end

  # Overrides

  def data_documento
    I18n.l(financial.data_documento.to_date)
  end

  def data_pagamento
    I18n.l(financial.data_pagamento.to_date)
  end


  private

  def self.spreadsheet_header_title(column)
    ::Integration::Contracts::Financial.human_attribute_name(column)
  end

  def self.columns
    COLUMNS
  end

  def columns
    self.class.columns
  end
end
