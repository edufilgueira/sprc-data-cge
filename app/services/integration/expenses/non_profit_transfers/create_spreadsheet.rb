#
# Cria planilha de despesas
#

class Integration::Expenses::NonProfitTransfers::CreateSpreadsheet < ::Integration::Expenses::BaseCreateSpreadsheet

  private

  def transparency_id
    :non_profit_transfer
  end

  def resource_klass
    Integration::Expenses::NonProfitTransfer
  end

  def file_name_prefix
    :transferencias_entidades_sem_fins_lucrativos
  end

  def presenter_klass
    Integration::Expenses::NonProfitTransfer::SpreadsheetPresenter
  end


  def worksheet_title(worksheet_type)
    I18n.t("integration/expenses/non_profit_transfer.spreadsheet.worksheets.default.title", year: year)
  end
end
