#
# Importador de dados do Web service de Indicadores temáticos
#
class Integration::Results::ThematicIndicatorsImporter
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
    import_thematic_indicators

    create_spreadsheet
  end

  protected

  def import_thematic_indicators
    import(:thematic_indicator)
  end

  def import_thematic_indicator(attributes, line)
    thematic_indicator = thematic_indicator(attributes)

    update_thematic_indicator(thematic_indicator, attributes, line)
  end


  # privates

  private

  def create_spreadsheet
    Integration::Results::ThematicIndicator::CreateSpreadsheet.call(reference_month.year, reference_month.month)
  end

  def thematic_indicator(attributes)
    find_or_initializer(Integration::Results::ThematicIndicator, attributes)
  end

  def update_thematic_indicator(thematic_indicator, attributes, line)
    update_associations(thematic_indicator, attributes)

    update(thematic_indicator, attributes, line)
  end

  def update_associations(thematic_indicator, attributes)
    thematic_indicator.organ  =   Integration::Supports::Organ.find_by(sigla: safe_strip(attributes[:sigla_orgao]), orgao_sfp: false)

    thematic_indicator.axis   =   Integration::Supports::Axis.find_by(codigo_eixo: safe_strip(attributes[:eixo][:codigo_eixo]))

    thematic_indicator.theme  =   Integration::Supports::Theme.find_by(codigo_tema: safe_strip(attributes[:tema][:codigo_tema]))
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
