#
# Cria planilha de receitas
#

class Integration::Revenues::Accounts::CreateSpreadsheet < ::BaseSpreadsheetService

  def worksheet_title(worksheet_type)
    I18n.t("integration/revenues/account.spreadsheet.worksheets.default.title", year: year)
  end

  private

  ## Spreadsheet

  def spreadsheet_object
    nil # é usado para models de export/report
  end

  def spreadsheet_dir_path
    Rails.root.to_s + "/public/files/downloads/integration/revenues/#{year}_#{month_start}_#{month_end}/"
  end

  def file_name(extension='xlsx')
    "receitas_poder_executivo_#{year}_#{month_start}_#{month_end}.#{extension}"
  end

  def resources
    Integration::Revenues::Account.
      joins({ revenue: :organ }, :revenue_nature).from_month_range(month_start, month_end, year).
      references({ revenue: :organ }, :revenue_nature)
  end

  def presenter_klass
    Integration::Revenues::Account::SpreadsheetPresenter
  end
end
