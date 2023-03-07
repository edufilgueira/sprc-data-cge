#
# Cria planilha de empreendimento de municipios
#
#

class Integration::CityUndertakings::CreateSpreadsheet < ::BaseSpreadsheetService

  def worksheet_title(worksheet_type)
    I18n.t("integration/city_undertakings.spreadsheet.worksheets.default.title", month: month, year: year)
  end

  private

  ## Spreadsheet

  def spreadsheet_object
    nil # é usado para models de export/report
  end

  def spreadsheet_dir_path
    Rails.root.to_s + "/public/files/downloads/integration/city_undertakings/#{year_month}/"
  end

  def file_name(extension)
    "empreendimentos_municipios_#{year_month}.#{extension}"
  end

  def resources
    Integration::CityUndertakings::CityUndertaking.all
  end

  def presenter_klass
    Integration::CityUndertakings::SpreadsheetPresenter
  end
end
