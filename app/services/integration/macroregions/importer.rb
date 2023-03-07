#
# Importador de dados do Web Service de Investimentos por macrorregioes
#
class Integration::Macroregions::Importer
  include BaseIntegrationsImporter

  attr_reader :configuration, :logger, :client

  def self.call(configuration_id)
    new(configuration_id).call
  end

  def initialize(configuration_id)
    @configuration = Integration::Macroregions::Configuration.find(configuration_id)

    @client = client_connection(@configuration.wsdl, @configuration.headers_soap_action)
  end

  def call
    start

    begin
      import_macroregions

      close_log
      @configuration.status_success!

    rescue StandardError => e
      log(:error, I18n.t('services.importer.log.error', e: e.message))

      close_log
      @configuration.status_fail!
    end
  end

  protected

  def import_macroregions
    import
    create_stats
    create_spreadsheet
  end

  def import
    line = 0

    resources.each do |attributes|
      line += 1

      import_macroregion(attributes, line)
    end

    log(:info, I18n.t('services.importer.log.macroregion', line: line))
  end


  private

  def import_macroregion(attributes, line)
    investiment = macroregion(attributes)

    update_associations(investiment, attributes)

    update(investiment, attributes, line)
  end

  def macroregion(attributes)
    find_or_initializer(Integration::Macroregions::MacroregionInvestiment, attributes)
  end

  def update_associations(investiment, attributes)
    investiment.power   = Integration::Macroregions::Power.find_by(power_attributes(attributes))

    investiment.region  = Integration::Macroregions::Region.find_or_create_by(region_attributes(attributes))
  end

  def find_or_initializer(model, attributes)
    model.find_or_initialize_by(
      ano_exercicio: attributes[:ano_exercicio],
      codigo_regiao: attributes[:codigo_regiao],
      codigo_poder: attributes[:codigo_poder]
    )
  end

  def reference_month
    Date.current
  end

  def message
    {
      usuario: @configuration.user,
      senha: @configuration.password,
      ano: @configuration.year,
      poder: @configuration.power
    }
  end

  def power_attributes(attributes)
    {
      code: safe_strip(attributes[:codigo_poder]),
      name: safe_strip(attributes[:descricao_poder])
    }
  end

  def region_attributes(attributes)
    {
      code: safe_strip(attributes[:codigo_regiao]),
      name: safe_strip(attributes[:descricao_regiao])
    }
  end

  def create_stats
    Integration::Macroregions::CreateStats.call(@configuration.year, reference_month.month)
  end

  def create_spreadsheet
    Integration::Macroregions::CreateSpreadsheet.call(@configuration.year, reference_month.month)
  end
end
