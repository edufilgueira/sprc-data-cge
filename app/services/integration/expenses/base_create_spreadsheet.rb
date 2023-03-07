#
# Cria planilha de despesas usada em (city_transfers, multi_gov_transfers, dailies, ...)
#

class Integration::Expenses::BaseCreateSpreadsheet < ::BaseSpreadsheetService

  def worksheet_title(worksheet_type)
    I18n.t("integration/expenses/#{transparency_id}.spreadsheet.worksheets.default.title", year: year)
  end

  private

  ## Spreadsheet

  def spreadsheet_object
    nil # é usado para models de export/report
  end

  def spreadsheet_dir_path
    Rails.root.to_s + "/public/files/downloads/integration/expenses/#{transparency_id.to_s.pluralize}/#{year}/"
  end

  def file_name(extension='xlsx')
    "#{file_name_prefix}_#{year}.#{extension}"
  end

  def associations
    [
      :management_unit,
      :executing_unit,
      :budget_unit,
      :function,
      :sub_function,
      :government_program,
      :government_action,
      :administrative_region,
      :expense_nature,
      :resource_source,
      :expense_type,
      :creditor
    ]
  end

  def resources
    resource_klass.
      from_executivo.
      from_year(year).
      includes(associations).
      references(associations)
  end
end
