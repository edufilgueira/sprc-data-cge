#
# Cria planilha dos receitas
#
#

class Integration::Revenues::RegisteredRevenues::CreateSpreadsheet < ::BaseSpreadsheetService

  def worksheet_title(worksheet_type)
    I18n.t("integration/revenues/registered_revenue.spreadsheet.worksheets.default.title", year: year)
  end

  private

  ## Spreadsheet

  def spreadsheet_object
    nil # é usado para models de export/report
  end

  def spreadsheet_dir_path
    Rails.root.to_s + "/public/files/downloads/integration/revenues/registered_revenues/#{year}/"
  end

  def file_name(extension='xlsx')
    "receitas_lancadas_#{year}.#{extension}"
  end

  def resources
    Integration::Revenues::RegisteredRevenue.from_year(year)
  end

  def presenter_klass
    Integration::Revenues::RegisteredRevenue::SpreadsheetPresenter
  end
end
