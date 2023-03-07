#
# Cria planilha dos convênios
#
#

class Integration::Contracts::Convenants::CreateSpreadsheet < ::BaseSpreadsheetService

  def worksheet_title(worksheet_type)
    I18n.t("integration/contracts/convenant.spreadsheet.worksheets.default.title", month: month, year: year)
  end

  private

  ## Spreadsheet

  def spreadsheet_object
    nil # é usado para models de export/report
  end

  def spreadsheet_dir_path
    Rails.root.to_s + "/public/files/downloads/integration/contracts/convenants/#{year_month}/"
  end

  def file_name(extension='xlsx')
    "convenios_#{year_month}.#{extension}"
  end

  def resources
    includes = [:grantor, :manager]
    Integration::Contracts::Convenant.includes(includes).active_on_month(date)
  end

  def presenter_klass
    Integration::Contracts::Convenant::SpreadsheetPresenter
  end
end
