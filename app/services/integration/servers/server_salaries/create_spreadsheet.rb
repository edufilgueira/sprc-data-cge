#
# Cria planilha dos servidores
#

class Integration::Servers::ServerSalaries::CreateSpreadsheet < ::BaseSpreadsheetService

  SEARCH_INCLUDES = {
    registration: [
      :server,
      :organ
    ],

    role: []
  }

  def worksheet_title(worksheet_type)
    I18n.t("integration/servers/server_salary.spreadsheet.worksheets.default.title", month: month, year: year)
  end

  private

  ## Spreadsheet


  def generate
    create_spreadsheet
    #create_csv Já faz junto do Spreadsheet
  end

  def spreadsheet_object
    nil # é usado para models de export/report
  end

  def spreadsheet_dir_path
    Rails.root.to_s + "/public/files/downloads/integration/servers/server_salaries/#{year_month}/"
  end

  def file_name(extension)
    "servidores_#{year_month}.#{extension}"
  end

  def resources
    Integration::Servers::ServerSalary
      .includes(:organ, :role)
      .from_date(date)
  end

  def presenter_klass
    Integration::Servers::ServerSalary::SpreadsheetPresenter
  end

  def create_spreadsheet
    resources.find_each do |resource|
      add_resource_to_worksheet(resource)
      add_resource_to_csv(resource)
    end
    xls_package.serialize(spreadsheet_file_path(:xlsx))
  end

  def add_resource_to_csv(resource)
    File.open(spreadsheet_file_path(:csv), "a+") do |csv|
      csv.print csv_add_row(resource)
    end
  end

  def csv_add_row(resource)
    presenter.new(resource).spreadsheet_row.to_csv
  end

  def presenter
    Integration::Servers::ServerSalary::SpreadsheetPresenter
  end
end
