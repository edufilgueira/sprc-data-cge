class Integration::Eparcerias::TransferBankOrder::SpreadsheetPresenter

  COLUMNS = [
    :numero_ordem_bancaria,
    :tipo_ordem_bancaria,
    :nome_benceficiario,
    :valor_ordem_bancaria,
    :data_pagamento
  ].freeze

  attr_reader :transfer_bank_order

  def initialize(transfer_bank_order)
    @transfer_bank_order = transfer_bank_order
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
        transfer_bank_order.send(column)
      end
    end
  end

  # Override
  def data_pagamento
    I18n.l(transfer_bank_order.data_pagamento.to_date)
  end


  private

  def self.spreadsheet_header_title(column)
    ::Integration::Eparcerias::TransferBankOrder.human_attribute_name(column)
  end

  def self.columns
    COLUMNS
  end

  def columns
    self.class.columns
  end
end
