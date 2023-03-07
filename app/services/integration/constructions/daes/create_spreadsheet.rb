#
# Cria planilha dos obras - dae
#

class Integration::Constructions::Daes::CreateSpreadsheet < ::BaseSpreadsheetService

  def worksheet_title(worksheet_type)
    I18n.t("integration/constructions/dae.spreadsheet.worksheets.default.title", month: month, year: year)
  end

  private

  ## Spreadsheet

  def spreadsheet_object
    nil # é usado para models de export/report
  end

  def spreadsheet_dir_path
    Rails.root.to_s + "/public/files/downloads/integration/constructions/daes/#{year_month}/"
  end

  def file_name(extension)
    "daes_#{year_month}.#{extension}"
  end

  def resources
    Integration::Constructions::Dae.active_on_month(date)
  end

  def presenter_klass
    Integration::Constructions::Dae::SpreadsheetPresenter
  end
end
