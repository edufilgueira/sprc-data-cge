#
# Gerador de planilha de indicadores temáticos
#
#
class Integration::Results::ThematicIndicator::CreateSpreadsheet < ::BaseSpreadsheetService

  def worksheet_title(worksheet_type)
    I18n.t("integration/results/thematic_indicator.spreadsheet.worksheets.default.short_title", month: month, year: year)
  end


  private

  ## Spreadsheet

  def spreadsheet_object
    nil # é usado para models de export/report
  end

  def spreadsheet_dir_path
    Rails.root.to_s + "/public/files/downloads/integration/results/thematic_indicators/#{year_month}/"
  end

  def file_name(extension)
    "results_thematic_indicator_#{year_month}.#{extension}"
  end

  def resources
    Integration::Results::ThematicIndicator.all
  end

  def presenter_klass
    Integration::Results::ThematicIndicator::SpreadsheetPresenter
  end
end
