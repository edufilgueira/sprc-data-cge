class Integration::Constructions::DerImporter
  include Integration::Constructions::BaseImporter

  NOT_ALLOWED_STATUS = ['EM LICITAÇÃO', 'EM PROJETO', 'NÃO INICIADO']

  attr_reader :configuration, :logger, :client

  def self.call(configuration_id, logger)
    new(configuration_id, logger).call
  end

  def initialize(configuration_id, logger)
    @logger = logger
    @configuration = Integration::Constructions::Configuration.find(configuration_id)
    @client = client_connection(@configuration.der_wsdl, @configuration.headers_soap_action)
  end

  def call
    import_ders
    create_stats
    create_spreadsheet
  end


  private

  def import_ders
    import(:der)
  end

  def import_der(attributes, line)
    line += 1

    return if not_allowed_status(attributes[:status])

    begin
      der = create_der(attributes)

      return unless der.numero_contrato_sic.present?

      import_der_measurements(fetch_der_measurement(der.numero_contrato_sic), der, line)

      import_der_coordinates(fetch_der_coordinates(der.numero_contrato_sic), der)

      update_der(der, fetch_der_contract(der.numero_contrato_sic), line)

    # rescues from detail fail request so we keep fetching
    rescue Savon::SOAPFault => e
      log(:error, I18n.t('services.importer.log.soap_fault', line: line, error: e.to_s))
    end
  end

  def not_allowed_status(status)
    NOT_ALLOWED_STATUS.include?(status)
  end

  def create_der(attributes)
    der = find_der(attributes[:id_obra])
    der.der_status = der_status[attributes[:status]]
    der.update_attributes(normalized_attributes(attributes))
    der
  end

  def update_der(der, attributes, line)
    attributes = whitelisted_attributes(attributes)
    update(der, attributes, line)
  end

  def whitelisted_attributes(attributes)
    attributes.except!(:data_fim_contrato, :data_fim_previsto, :numero_contrato_sacc, :latitude, :longitude)
  end

  def import_der_measurements(attributes, der, line)
    attributes.each do |attribute|
      next if der.id_obra.to_i != attribute[:id_obra].to_i
      measurement = der.measurements.find_or_initialize_by(id_obra: attribute[:id_obra], id_medicao: attribute[:id_medicao])
      measurement.ano_mes_date = measurement_ano_mes(attribute[:ano_mes])
      update(measurement, attribute, line)
    end
  end

  def import_der_coordinates(attributes, der)
    #
    # as coordenadas são sobreescritas, pois o métodos do WS não retorna tadas as coordenadas
    der.latitude = convert_coordinate_to_decimal(attributes[:latitude])
    der.longitude = convert_coordinate_to_decimal(attributes[:longitude])
  end

  def measurement_ano_mes(ano_mes)
    Date.new(ano_mes[0..3].to_i, ano_mes[4..5].to_i) rescue nil
  end

  # TODO: move to another importer
  def der_contract_response_path
    @configuration.der_contract_response_path.split('/').map(&:to_sym)
  end

  def fetch_der_contract(sacc)
    result_fetch = der_contract_response_path.inject(der_contract_body(sacc)) do |result, key|
      result[key] || {}
    end

    result_fetch.is_a?(Array) ? result_fetch.first : result_fetch
  end

  def der_contract_body(sacc)
    der_contract_response(sacc).body
  end

  def der_contract_operation
    @configuration.der_contract_operation.to_sym
  end

  def der_contract_response(sacc)
    @client.call(der_contract_operation, advanced_typecasting: false, message: der_contract_message(sacc))
  end

  def der_contract_message(sacc)
    default_message.merge({ filtro: { numeroContrato: sacc }})
  end

  def der_measurement_response_path
    @configuration.der_measurement_response_path.split('/').map(&:to_sym)
  end

  def der_coordinates_response_path
    @configuration.der_coordinates_response_path.split('/').map(&:to_sym)
  end

  def fetch_der_measurement(sacc)
    result_array = der_measurement_response_path.inject(der_measurement_body(sacc)) do |result, key|
      result[key] || {}
    end

    ensure_resource_type(result_array)
  end

  def fetch_der_coordinates(sacc)
    result_array = der_coordinates_response_path.inject(der_coordinates_body(sacc)) do |result, key|
      result[key] || {}
    end

    # ensure_resource_type(result_array)
    result_array
  end

  def der_measurement_body(sacc)
    der_measurement_response(sacc).body
  end

  def der_coordinates_body(sacc)
    der_coordinates_response(sacc).body
  end

  def der_measurement_operation
    @configuration.der_measurement_operation.to_sym
  end

  def der_coordinates_operation
    @configuration.der_coordinates_operation.to_sym
  end

  def der_measurement_response(sacc)
    @client.call(der_measurement_operation, advanced_typecasting: false, message: der_measurement_message(sacc))
  end

  def der_coordinates_response(sacc)
    @client.call(der_coordinates_operation, advanced_typecasting: false, message: der_coordinates_message(sacc))
  end

  def der_measurement_message(sacc)
    default_message.merge({ numeroContratoSacc: sacc })
  end

  def der_coordinates_message(sacc)
    default_message.merge({ numero_contrato_sacc: sacc })
  end
  # END TODO


  def year_month
    today = Date.today
    {
      year: today.year,
      month: today.month
    }
  end

  def create_stats
    Integration::Constructions::Ders::CreateStats.call(year_month[:year], year_month[:month])
  end

  def create_spreadsheet
    Integration::Constructions::Ders::CreateSpreadsheet.call(year_month[:year], year_month[:month])
  end

  # Helpers

  def find_der(id_obra)
    Integration::Constructions::Der.find_or_initialize_by(id_obra: id_obra)
  end

  def der_status
    {
      'CANCELADO'=>:canceled,
      'CONCLUÍDO'=>:done,
      'EM ANDAMENTO'=>:in_progress,
      'EM PROJETO'=>:in_project,
      'EM LICITAÇÃO'=>:in_bidding,
      'NÃO INICIADO'=>:not_started,
      'PARALISADO'=>:paused,
      'PROJETO CONCLUÍDO'=>:project_done,
      'LICITADO/ CONTRATADO'=>:bid
    }
  end

  def convert_coordinate_to_decimal(full_degrees)
    # input  => 06°01,8129' S
    # output => -6.030215
    #
    # vamos desconsiderar a orientação dos paralelos e meridianos
    # pois sabemos que no ceará todas a coordenadas são
    # S (sul) e W (Oeste) e otimizamos a conversão
    # https://www.pgc.umn.edu/apps/convert/
    degrees, min = full_degrees.to_s&.split('°')
    return 0 unless degrees && min # retorna caso o scan não encontre os 3 pontos
    min = min.split("'").first.gsub(',', '.')
    decimal_coordinate = ((min.to_f / 60) + degrees.to_f).round(8) * -1
    decimal_coordinate.to_s
  end

end
