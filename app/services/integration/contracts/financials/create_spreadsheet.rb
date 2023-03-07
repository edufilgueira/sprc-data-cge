#
# Serviço responsável por criar as planilhas de Notas de Empenho e Pagamentos
#
# Somente são criados as planilhas de contratos/convênios que possuem mais de 20 neds para otimizar a performance
# as demais planilhas são geradas em foreground por uma gem
#
# O serviço pode receber isn_sic específicos para atualizar apenas alguns registros.
# Caso não seja passado o array de sics, todos os convênios que possuem mais de 20 NEDs são carregadas e as OBTS processadas gerando uma planilha por convênio
#
class Integration::Contracts::Financials::CreateSpreadsheet
  MIN_NEDS = 20

  attr_reader :worksheets, :contract, :isn_sics

  def initialize(isn_sics = nil)
    @isn_sics = isn_sics
  end

  def call
    create_dir
    generate
  end

  def self.call(isn_sics = nil)
    new(isn_sics).call
  end

  private

  def generate
    create_worksheets
  end

  def resources
    #
    # agrupamento dos isn_sic dos convênios que possuem mais de 20 NEDs
    #
    count_hash = base_resources.
      having("COUNT(integration_contracts_financials.isn_sic) > #{MIN_NEDS}").
      group('integration_contracts_financials.isn_sic').count

    # unscoped pois pode ser contrato ou convênio
    @resources ||= Integration::Contracts::Contract.unscoped.where(isn_sic: count_hash.keys)
  end

  def base_resources
    results = Integration::Contracts::Financial

    if isn_sics.present?
      return results.where('integration_contracts_financials.isn_sic IN (?)', isn_sics)
    end

    results
  end

  def create_worksheets
    resources.each do |resource|
      @contract = resource

      create_spreadsheet

      create_csv
    end
  end

  def create_spreadsheet
    p = Axlsx::Package.new
    p.workbook.add_worksheet(name: worksheet_title) do |sheet|
      sheet.add_row header
      @contract.financials.find_each(batch_size: 3000) do |financial|
        add_row_to_xlsx(sheet, financial)
      end
    end
    p.serialize(spreadsheet_file_path(:xlsx))
  end

  def add_resource_to_worksheet(resource)
    xls_worksheet(:default) do |sheet|
      presenter = presenter_klass.new(resource)
      xls_add_row(sheet, presenter.spreadsheet_row)
    end
  end

  def header
    presenter_klass.spreadsheet_header
  end

  def add_row_to_xlsx(sheet, resource)
    data = presenter_klass.new(resource).spreadsheet_row
    sheet.add_row data
  end

  def presenter_klass
    Integration::Contracts::Financials::SpreadsheetPresenter
  end

  def create_dir
    FileUtils.mkdir_p(spreadsheet_dir_path) unless File.exist?(spreadsheet_dir_path)
  end

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

  # @SPRC -> Métodos duplicados em: sprc/app/controllers/transparency/contracts/financials_controller.rb
  def worksheet_title
    I18n.t("integration/contracts/financial.spreadsheet.worksheets.default.title")
  end

  def spreadsheet_dir_path
    Rails.root.to_s + "/public/files/downloads/integration/contracts/financials"
  end

  def file_name(extension)
    "financial_#{@contract.isn_sic}.#{extension}"
  end

   def spreadsheet_file_path(extension)
    "#{spreadsheet_dir_path}/#{file_name(extension)}"
  end
  # @SPRC -> Métodos duplicados em: sprc/app/controllers/transparency/contracts/financials_controller.rb
end
