#
# Importador de dados do Web Service de Empreendimentos de municipios
#
class Integration::CityUndertakings::Importer
  include BaseIntegrationsImporter

  attr_reader :configuration, :logger, :client

  def self.call(configuration_id)
    new(configuration_id).call
  end

  def initialize(configuration_id)
    @configuration = Integration::CityUndertakings::Configuration.find(configuration_id)
    @client = client_connection(@configuration.wsdl, @configuration.headers_soap_action)
  end

  def call
    start

    @line = 0
    @cities = State.default.cities

    begin
      import_city_undertakings

      close_log
      @configuration.status_success!

    rescue StandardError => e
      log(:error, I18n.t('services.importer.log.error', e: e.message))

      close_log
      @configuration.status_fail!
    end
  end

  protected

  def import_city_undertakings
    import
    create_stats
    create_spreadsheet
  end

  def import
    import_undertakings(resources('undertaking'))

    log(:info, I18n.t("services.importer.log.city_undertaking", line: @line))
  end

  private

  def import_undertakings(resources)
    resources.each do |attributes|
      @line += 1
      next unless attributes[:descricao].present?
      undertaking = Integration::Supports::Undertaking.find_or_create_by(descricao: safe_strip(attributes[:descricao]))
      import_city_undertakings_from_undertaking(undertaking)
    end
  end

  def create_stats
    Integration::CityUndertakings::CreateStats.call(reference_month.year, reference_month.month)
  end

  def create_spreadsheet
    Integration::CityUndertakings::CreateSpreadsheet.call(reference_month.year, reference_month.month)
  end


  def city_undertaking_response_path
    @configuration.city_undertaking_response_path.split('/').map(&:to_sym)
  end

  def fetch_city_undertaking(city_name, undertaking_title)
    result_array = city_undertaking_response_path.inject(city_undertaking_body(city_name, undertaking_title)) do |result, key|
      result[key] || {}
    end

    ensure_resource_type(result_array)
  end

  def city_undertaking_body(city_name, undertaking_title)
    city_undertaking_response(city_name, undertaking_title).body
  end

  def city_undertaking_operation
    @configuration.city_undertaking_operation.to_sym
  end

  def city_undertaking_response(city_name, undertaking_title)
    @client.call(city_undertaking_operation, advanced_typecasting: false, message: city_undertaking_message(city_name, undertaking_title))
  end

  def city_undertaking_message(city_name, undertaking_title)
    default_message.merge({ municipio: city_name, empreendimento: undertaking_title })
  end

  def import_city_undertakings_from_undertaking(undertaking)
    @cities.each do |city|
      begin
        child_resources = fetch_city_undertaking(city.name, undertaking.title)

        child_resources.each do |attributes|
          attributes = normalized_attributes!(attributes)

          update_city_undertaking(city_undertaking(attributes, undertaking), attributes)
        end

      # rescues from city_undertaking fail request so we keep fetching
      rescue Savon::SOAPFault => e

        log(:error, I18n.t('services.importer.log.soap_fault', line: @line, error: e.to_s))
      end
    end
  end

  def normalized_attributes!(attributes)
    attributes.merge!({
      municipio: safe_strip(attributes[:municipio]),
      mapp: safe_strip(attributes[:mapp]),
      sic: safe_strip(attributes[:sic]),
      orgao: safe_strip(attributes[:orgao]),
      empreendimento: safe_strip(attributes[:empreendimento]),
      credor: safe_strip(attributes[:credor])
    })
  end

  def city_undertaking(attributes, undertaking)
    find_or_initializer(Integration::CityUndertakings::CityUndertaking, attributes, undertaking)
  end

  def update_city_undertaking(city_undertaking, attributes)
    city_undertaking = update_expense(city_undertaking, attributes)
    update_associations(city_undertaking, attributes)
    update(city_undertaking, attributes, @line)
  end

  def update_expense(city_undertaking, attributes)
    case attributes[:tipo_despesa]
    when 'CONVENIO' then city_undertaking.expense = :convenant
    when 'CONTRATO' then city_undertaking.expense = :contract
    end

    city_undertaking
  end

  def update_associations(city_undertaking, attributes)
    city_undertaking.organ =    Integration::Supports::Organ.find_by(sigla: attributes[:orgao], orgao_sfp: false)
    city_undertaking.creditor = Integration::Supports::Creditor.find_by(cpf_cnpj: cpf_cnpj(attributes[:credor]))
  end

  def find_or_initializer(model, attributes, resource)
    model.find_or_initialize_by(
      municipio: attributes[:municipio],
      mapp: attributes[:mapp],
      sic: attributes[:sic],
      undertaking_id: resource.id
    )
  end

  def cpf_cnpj(credor)
    # o atributo credor vem: NOME - CNPJ, então para evitar um credor com mesmo
    # nome nós buscamos pelo seu CPF/CNPJ
    (credor || '').split(' - ')[-1]&.gsub(/[^\d]/, '')
  end

  def reference_month
    # web service doesn't have month/year filter
    Date.current
  end

  def message(prefix=nil)
    default_message
  end
end
