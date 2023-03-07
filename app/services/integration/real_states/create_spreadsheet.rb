#
# Cria planilha de bens imóveis
#
#

class Integration::RealStates::CreateSpreadsheet < ::BaseSpreadsheetService

  def worksheet_title(worksheet_type)
    I18n.t("integration/real_states.spreadsheet.worksheets.default.title", month: month, year: year)
  end

  private

  ## Spreadsheet

  def spreadsheet_object
    nil # é usado para models de export/report
  end

  def spreadsheet_dir_path
    Rails.root.to_s + "/public/files/downloads/integration/real_states/#{year_month}/"
  end

  def file_name(extension)
    "bens_imoveis_#{year_month}.#{extension}"
  end

  def resources
    Integration::RealStates::RealState.all
  end

  def presenter_klass
    Integration::RealStates::SpreadsheetPresenter
  end
end
