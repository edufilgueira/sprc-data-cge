##
# Métodos compartilhados pelos geradores de planilhas da área de transparência
#
##

class ::BaseSpreadsheetService

  attr_reader :worksheets, :year, :month, :month_start, :month_end

  def initialize(year, month, month_range = nil)
    # guarda a contagem de títulos repetidos pois não deve ter
    # 2 worksheets com mesmo nome.
    @worksheet_titles = nil

    @worksheets = {}

    @year = year
    @month = month

    if month_range.present?
      @month_start = month_range[:month_start]
      @month_end = month_range[:month_end]
    end
  end

  def call
    create_dir

    generate
  end

  def self.call(year, month, month_range = nil)
    new(year, month, month_range).call
  end

  def date
    @data ||= Date.new(year, month)
  end

  def year_month
    @year_month ||= I18n.l(date, format: '%Y%m')
  end

  private

  def generate
    create_spreadsheet
    create_csv
  end

  def create_spreadsheet
    resources.find_each(batch_size: 3000).with_index do |resource, index|
      add_resource_to_worksheet(resource)
    end

    xls_package.serialize(spreadsheet_file_path(:xlsx))
  end

  def add_resource_to_worksheet(resource)
    xls_worksheet(:default) do |sheet|
      presenter = presenter_klass.new(resource)
      xls_add_row(sheet, presenter.spreadsheet_row)
    end
  end

  def header(worksheet_type)
    presenter_klass.spreadsheet_header
  end

  def worksheet_title(worksheet_type)
    # deve ser sobrescrito
  end

  def spreadsheet_dir_path
    # deve ser sobrescrito
  end

  def file_name(extension)
    # deve ser sobrescrito
  end

  def spreadsheet_file_path(extension)
    "#{spreadsheet_dir_path}/#{file_name(extension)}"
  end

  def create_dir
    FileUtils.rm_rf(spreadsheet_dir_path) if File.exist?(spreadsheet_dir_path)
    FileUtils.mkdir_p(spreadsheet_dir_path)
  end

  # CSV

  def create_csv
    begin
      xlsx = Roo::Excelx.new(spreadsheet_file_path(:xlsx), { expand_merged_ranges: true })
      csv_content = xlsx.to_csv(nil, ';')

      # adds invalid and undef so it won't explode
      encoded = csv_content.encode('iso8859-1', invalid: :replace, undef: :replace)

      File.open(spreadsheet_file_path(:csv), 'w:iso8859-1') do |f|
        f.write encoded
      end
    rescue Roo::FileNotFound, ArgumentError
      # para que os testes que não possuem tudo não explodam
    end
  end

  ## XLS

  def xls_package
    @xls_package ||= ::Axlsx::Package.new
  end

  def xls_workbook
    @xls_workbook ||= xls_package.workbook
  end

  def xls_add_worksheet(worksheet_type)
    worksheet_title = sanitized_worksheet_title(worksheet_type)

    xls_workbook.add_worksheet(name: worksheet_title) do |sheet|
      unless worksheet_type == :summary
        xls_add_header(sheet, header(worksheet_type))
      end

      yield sheet
    end
  end

  def xls_add_header(sheet, header)
    sheet.add_row(header, style: xls_default_header_style(sheet))
  end

  def xls_add_row(sheet, row)
    sheet.add_row(row, style: xls_default_row_style(sheet))
  end

  def xls_add_empty_rows(sheet, count=1)
    count.times do
      sheet.add_row []
    end
  end

  def xls_default_row_style(sheet)
    @xls_default_row_style ||=
      sheet.styles.add_style({
        border: xls_default_border_style,

        alignment: {
          vertical: :top
        }
      })
  end

  def xls_default_header_style(sheet)
    @xls_default_header_style ||=
      sheet.styles.add_style({
        border: xls_default_border_style,

        alignment: {
          vertical: :center
        },

        bg_color: 'FFF0F0F0',
        fg_color: 'FF000000',
        b: true
      })
  end

  def xls_default_border_style
    { style: :thin, color: 'FF000000' }
  end

  def xls_worksheet(worksheet_type)
    if worksheets[worksheet_type].blank?
      xls_add_worksheet(worksheet_type) do |sheet|
        worksheets[worksheet_type] = sheet
        yield worksheets[worksheet_type]
      end
    else
      yield worksheets[worksheet_type]
    end
  end

  #
  # Os nomes devem ter menos de 31 caraceteres e não pode ser repetidos.
  def sanitized_worksheet_title(worksheet_type)
    title = worksheet_title(worksheet_type)
    sliced_title = title.slice(0, 25)

    initialize_worksheet_titles

    @worksheet_titles[sliced_title] = 0 if @worksheet_titles[sliced_title].blank?

    existing_count = (@worksheet_titles[sliced_title] += 1)

    if (existing_count > 1)
      new_title = "#{sliced_title}_#{existing_count + 1}"
      return new_title
    end

    sliced_title
  end

  def initialize_worksheet_titles
    if @worksheet_titles.blank?
      @worksheet_titles = {}
      xls_workbook.worksheets.each do |sheet|
        @worksheet_titles[sheet.name] = 1
      end
    end
  end
end
