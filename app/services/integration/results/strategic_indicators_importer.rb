#
# Importador de dados do Web service de Indicadores estratégicos
#
class Integration::Results::StrategicIndicatorsImporter
  include Integration::Results::BaseImporter

  attr_reader :configuration, :logger, :client

  def self.call(configuration_id, logger)
    new(configuration_id, logger).call
  end

  def initialize(configuration_id, logger)
    @logger = logger

    @configuration = Integration::Results::Configuration.find(configuration_id)

    @client = client_connection(@configuration.wsdl, @configuration.headers_soap_action)
  end

  def call
    import_strategic_indicators

    create_spreadsheet
  end

  protected

  def import_strategic_indicators
    import(:strategic_indicator)
  end

  def import_strategic_indicator(attributes, line)
    strategic_indicator = strategic_indicator(attributes)

    update_strategic_indicator(strategic_indicator, attributes, line)
  end


  # privates

  private

  def create_spreadsheet
    Integration::Results::StrategicIndicators::CreateSpreadsheet.call(reference_month.year, reference_month.month)
  end

  def strategic_indicator(attributes)
    find_or_initializer(Integration::Results::StrategicIndicator, attributes)
  end

  def update_strategic_indicator(strategic_indicator, attributes, line)
    update_associations(strategic_indicator, attributes)

    update(strategic_indicator, attributes, line)
  end

  def update_associations(strategic_indicator, attributes)
    strategic_indicator.organ =   Integration::Supports::Organ.find_by(sigla: safe_strip(attributes[:sigla_orgao]), orgao_sfp: false)

    strategic_indicator.axis  =   Integration::Supports::Axis.find_by(codigo_eixo: safe_strip(attributes[:eixo][:codigo_eixo]))
  end

  def find_or_initializer(model, attributes)
    model.find_or_initialize_by(
      indicador: attributes[:indicador]
    )
  end

  def reference_month
    # O serviço não possui nenhum atributo para indicar data
    Date.current
  end

end
