#
# Cria planilha dos receitas
#
#

class Integration::Revenues::Transfers::CreateSpreadsheet < ::BaseSpreadsheetService

  def worksheet_title(worksheet_type)
    I18n.t("integration/revenues/transfer.spreadsheet.worksheets.default.title", year: year)
  end

  private

  ## Spreadsheet

  def spreadsheet_object
    nil # é usado para models de export/report
  end

  def spreadsheet_dir_path
    Rails.root.to_s + "/public/files/downloads/integration/revenues/transfers/#{year}/"
  end

  def file_name(extension='xlsx')
    "receitas_poder_executivo_transferencias_#{year}.#{extension}"
  end

  def resources
    Integration::Revenues::Transfer.
      joins({ revenue: :organ }, :revenue_nature).from_year(year).
      references({ revenue: :organ }, :revenue_nature)
  end

  def presenter_klass
    Integration::Revenues::Transfer::SpreadsheetPresenter
  end
end
