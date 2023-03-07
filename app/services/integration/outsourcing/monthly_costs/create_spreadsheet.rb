#
# Cria planilha investimentos por macroregiao
#
#
class Integration::Outsourcing::MonthlyCosts::CreateSpreadsheet < ::BaseSpreadsheetService

  def worksheet_title(worksheet_type)

    #I18n.t("integration/outsourcing/monthly_cost.spreadsheet.worksheets.default.title", month: month, year: year)
    "Custo Mensal com Terceirizados"
  end

  private

  ## Spreadsheet

  def spreadsheet_object
    nil # é usado para models de export/report
  end

  def spreadsheet_dir_path
    Rails.root.to_s + "/public/files/downloads/integration/outsourcing_monthly_costs/#{year_month}/"
  end

  def file_name(extension)
    "custo_mensal_terceirizados_#{year_month}.#{extension}"
  end

  def resources
    Integration::Outsourcing::MonthlyCost.where(competencia: "#{month.to_s.rjust(2, '0')}/#{year}")
  end

  def presenter_klass
    Integration::Outsourcing::MonthlyCosts::SpreadsheetPresenter
  end
end
