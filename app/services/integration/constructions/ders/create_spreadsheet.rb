#
# Cria planilha dos obras - der
#

class Integration::Constructions::Ders::CreateSpreadsheet < ::BaseSpreadsheetService

  def worksheet_title(worksheet_type)
    I18n.t("integration/constructions/der.spreadsheet.worksheets.default.title", month: month, year: year)
  end

  private

  ## Spreadsheet

  def spreadsheet_object
    nil # é usado para models de export/report
  end

  def spreadsheet_dir_path
    Rails.root.to_s + "/public/files/downloads/integration/constructions/ders/#{year_month}/"
  end

  def file_name(extension)
    "ders_#{year_month}.#{extension}"
  end

  def resources
    Integration::Constructions::Der.active_on_month(date)
  end

  def presenter_klass
    Integration::Constructions::Der::SpreadsheetPresenter
  end
end
