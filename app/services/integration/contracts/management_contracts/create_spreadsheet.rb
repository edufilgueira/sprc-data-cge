#
# Cria planilha dos contratos de gestão
#
#

class Integration::Contracts::ManagementContracts::CreateSpreadsheet < ::BaseSpreadsheetService

  def worksheet_title(worksheet_type)
    I18n.t("integration/contracts/contract.spreadsheet.worksheets.default.title", month: month, year: year)
  end

  private

  ## Spreadsheet

  def spreadsheet_object
    nil # é usado para models de export/report
  end

  def spreadsheet_dir_path
    Rails.root.to_s + "/public/files/downloads/integration/contracts/management_contracts/#{year_month}/"
  end

  def file_name(extension='xlsx')
    "contratos_de_gestao_#{year_month}.#{extension}"
  end

  def resources
    Integration::Contracts::ManagementContract.active_on_month(date)
  end

  def presenter_klass
    Integration::Contracts::Contract::SpreadsheetPresenter
  end
end
