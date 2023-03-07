#
# Cria planilha dos contratos
#
#

class Integration::Contracts::Contracts::CreateSpreadsheet < ::BaseSpreadsheetService

  def worksheet_title(worksheet_type)
    I18n.t("integration/contracts/contract.spreadsheet.worksheets.default.title", month: month, year: year)
  end

  private

  ## Spreadsheet

  def spreadsheet_object
    nil # é usado para models de export/report
  end

  def spreadsheet_dir_path
    Rails.root.to_s + "/public/files/downloads/integration/contracts/contracts/#{year_month}/"
  end

  def file_name(extension='xlsx')
    "contratos_#{year_month}.#{extension}"
  end

  def resources
    includes = [:grantor, :manager]
    Integration::Contracts::Contract.contrato.includes(includes).active_on_month(date)
  end

  def presenter_klass
    Integration::Contracts::Contract::SpreadsheetPresenter
  end
end
