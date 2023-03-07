#
# Cria planilha de compras
#
#

class Integration::Purchases::CreateSpreadsheet < ::BaseSpreadsheetService

  def worksheet_title(worksheet_type)
    I18n.t("integration/purchases.spreadsheet.worksheets.default.title", month: month, year: year)
  end

  private

  ## Spreadsheet

  def spreadsheet_object
    nil # é usado para models de export/report
  end

  def spreadsheet_dir_path
    Rails.root.to_s + "/public/files/downloads/integration/purchases/#{year_month}/"
  end

  def file_name(extension)
    "compras_#{year_month}.#{extension}"
  end

  def resources
    Integration::Purchases::Purchase.active_on_month(date)
  end

  def presenter_klass
    Integration::Purchases::SpreadsheetPresenter
  end
end
