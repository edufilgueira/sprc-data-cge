class Integration::Constructions::DaeImporter
  include Integration::Constructions::BaseImporter

  attr_reader :configuration, :logger, :client

  def self.call(configuration_id, logger)
    new(configuration_id, logger).call
  end

  def initialize(configuration_id, logger)
    @logger = logger
    @configuration = Integration::Constructions::Configuration.find(configuration_id)
    @client = client_connection(@configuration.dae_wsdl, @configuration.headers_soap_action)
  end

  def call
    import_daes
    create_stats
    create_spreadsheet
  end

  private

  def import_daes
    import(:dae)
  end

  def import_dae(attributes, line)
    line += 1

    begin
      dae = create_dae(attributes)

      return unless dae.codigo_obra.present?

      import_dae_measurements(fetch_dae_measurement(dae.codigo_obra), dae, line)

    #rescues from detail fail request so we keep fetching
    rescue Savon::SOAPFault => e
      log(:error, I18n.t('services.importer.log.soap_fault', line: line, error: e.to_s))
    end
  end

  def create_dae(attributes)
    dae = find_dae(attributes[:id_obra])

    dae.dae_status = dae_status[attributes[:status]]
    dae.organ = dae_organ(attributes)
    dae.update_attributes(normalized_attributes(attributes))

    dae
  end

  def dae_organ(attributes)
    sigla = safe_strip(attributes[:secretaria])

    sigla = supports_organ_sigla[sigla] if supports_organ_sigla[sigla].present?

    Integration::Supports::Organ.find_by(sigla: sigla, orgao_sfp: false)
  end

  # XXX
  def supports_organ_sigla
    {
      'S. CIDADES'=> 'SCIDADES',
      'S.ESPORTES'=> 'SESPORTE',
      'P.CIVIL'=> 'PC'
    }
  end

  # MEASUREMENTS

  def import_dae_measurements(attributes, dae, line)
    attributes.each do |attribute|
      next if dae.codigo_obra.to_i != attribute[:codigo_obra].to_i
      measurement = dae.measurements.find_or_initialize_by(codigo_obra: attribute[:codigo_obra], id_medicao: attribute[:id_medicao])

      measurement.ano_mes_date = measurement_ano_mes(attribute[:ano_mes])
      measurement.id_servico = attribute[:id]

      update(measurement, dae_measurement_whitelisted_attributes(attribute), line)

      next unless measurement.persisted?
      # só busca fotos se o measurement for válido
      import_dae_photos(fetch_dae_photo(measurement.codigo_obra, measurement.id_medicao), dae, measurement, line)
    end
  end

  def dae_measurement_whitelisted_attributes(attributes)
    attributes.except(:id)
  end

  def dae_measurement_response_path
    @configuration.dae_measurement_response_path.split('/').map(&:to_sym)
  end

  def fetch_dae_measurement(codigo_obra)
    result_array = dae_measurement_response_path.inject(dae_measurement_body(codigo_obra)) do |result, key|
      result[key] || {}
    end

    ensure_resource_type(result_array)
  end

  def dae_measurement_body(codigo_obra)
    dae_measurement_response(codigo_obra).body
  end

  def dae_measurement_operation
    @configuration.dae_measurement_operation.to_sym
  end

  def dae_measurement_response(codigo_obra)
    @client.call(dae_measurement_operation, advanced_typecasting: false, message: dae_measurement_message(codigo_obra))
  end

  def dae_measurement_message(codigo_obra)
    default_message.merge({ codigo_obra: codigo_obra })
  end

  # END MEASUREMENTS

  # PHOTOS

  def import_dae_photos(attributes, dae, measurement, line)
    attributes.each do |attribute|
      next if different_photo_attributes?(attribute, measurement)
      photo = dae.photos.find_or_initialize_by(codigo_obra: attribute[:codigo_obra], id_medicao: attribute[:id_medicao])

      update(photo, attribute, line)
    end
  end

  def different_photo_attributes?(attribute, measurement)
    (measurement.codigo_obra.to_i != attribute[:codigo_obra].to_i) ||
    (measurement.id_medicao.to_i != attribute[:id_medicao].to_i)
  end

  def dae_photo_response_path
    @configuration.dae_photo_response_path.split('/').map(&:to_sym)
  end

  def fetch_dae_photo(codigo_obra, id_medicao)
    result_array = dae_photo_response_path.inject(dae_photo_body(codigo_obra, id_medicao)) do |result, key|
      result[key] || {}
    end

    ensure_resource_type(result_array)
  end

  def dae_photo_body(codigo_obra, id_medicao)
    dae_photo_response(codigo_obra, id_medicao).body
  end

  def dae_photo_operation
    @configuration.dae_photo_operation.to_sym
  end

  def dae_photo_response(codigo_obra, id_medicao)
    @client.call(dae_photo_operation, advanced_typecasting: false, message: dae_photo_message(codigo_obra, id_medicao))
  end

  def dae_photo_message(codigo_obra, id_medicao)
    default_message.merge({ codigo_obra: codigo_obra, id_medicao: id_medicao })
  end

  # END PHOTOS

  def create_stats
    Integration::Constructions::Daes::CreateStats.call(year_month[:year], year_month[:month])
  end

  def create_spreadsheet
    Integration::Constructions::Daes::CreateSpreadsheet.call(year_month[:year], year_month[:month])
  end

  # Helpers

  def find_dae(id_obra)
    Integration::Constructions::Dae.find_or_initialize_by(id_obra: id_obra)
  end

  def year_month
    today = Date.today
    {
      year: today.year,
      month: today.month
    }
  end

  def measurement_ano_mes(ano_mes)
    Date.new(ano_mes[0..3].to_i, ano_mes[4..5].to_i) rescue nil
  end

  def dae_status
    {
      'Aguardando OS'=>:waiting,
      'Cancelada'=>:canceled,
      'Concluida'=>:done,
      'Concluída'=>:done,
      'Em Execução'=>:in_progress,
      'Finalizada'=>:finished,
      'Paralisada'=>:paused
    }
  end

end
