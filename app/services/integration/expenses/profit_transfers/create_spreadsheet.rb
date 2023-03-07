#
# Cria planilha de despesas
#

class Integration::Expenses::ProfitTransfers::CreateSpreadsheet < ::Integration::Expenses::BaseCreateSpreadsheet

  private

  def transparency_id
    :profit_transfer
  end

  def resource_klass
    Integration::Expenses::ProfitTransfer
  end

  def file_name_prefix
    :transferencias_entidades_com_fins_lucrativos
  end

  def presenter_klass
    Integration::Expenses::ProfitTransfer::SpreadsheetPresenter
  end


  def worksheet_title(worksheet_type)
    I18n.t("integration/expenses/profit_transfer.spreadsheet.worksheets.default.title", year: year)
  end
end
