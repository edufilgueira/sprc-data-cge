#
# Cria planilha investimentos por macroregiao
#
#
class Integration::Macroregions::CreateSpreadsheet < ::BaseSpreadsheetService

  def worksheet_title(worksheet_type)
    I18n.t("integration/macroregions.spreadsheet.worksheets.default.title", month: month, year: year)
  end

  private

  ## Spreadsheet

  def spreadsheet_object
    nil # é usado para models de export/report
  end

  def spreadsheet_dir_path
    Rails.root.to_s + "/public/files/downloads/integration/macroregions/#{year_month}/"
  end

  def file_name(extension)
    "macroregions_#{year_month}.#{extension}"
  end

  def resources
    Integration::Macroregions::MacroregionInvestiment.all
  end

  def presenter_klass
    Integration::Macroregions::SpreadsheetPresenter
  end
end
