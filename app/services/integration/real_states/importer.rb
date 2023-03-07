#
# Importador de dados do Web Service de Compras
#
class Integration::RealStates::Importer < Integration::Supports::BaseSupportsImporter

  PAGINATION_LIMIT = 180.freeze

  attr_reader :reference_month

  def initialize(configuration_id)
    super

    # Precisamos guardar o valor do mês antes, e não depender mais do
    # configuration, para permitir que outros processo de
    # importação rodem paralelo e que as estatísticas/planilhas, criadas no
    # final do processo, sejam geradas com a data esperada.

    @reference_month = Date.current # web service doesn't have month/year filter
  end

  def call
    start

    begin
      import_real_states

      close_log
      @configuration.status_success!

    rescue StandardError => e
      log(:error, I18n.t('services.importer.log.error', e: e.message))

      close_log
      @configuration.status_fail!
    end
  end

  protected

  def import_real_states
    import
    create_stats
    create_spreadsheet
  end

  def import
    # XXX: o serviço está retornando erro 500 na página 5

    @line = 0
    @page = 1
    next_page = true

    while next_page do
      begin
        paginated_resources = resources
        import_current_page(paginated_resources)

        next_page = paginated_resources.present?

        @page += 1
      rescue StandardError => e
        break
      end
    end

    log(:info, I18n.t("services.importer.log.real_state", line: @line))
  end

  private

  def import_current_page(resources)
    resources.each do |attributes|
      @line += 1
      next unless attributes[:id].present?
      import_real_state(attributes)
    end
  end

  def create_stats
    Integration::RealStates::CreateStats.call(reference_month.year, reference_month.month)
  end

  def create_spreadsheet
    Integration::RealStates::CreateSpreadsheet.call(reference_month.year, reference_month.month)
  end


  # TODO: move detail resource to another Importer
  def detail_response_path
    @configuration.detail_response_path.split('/').map(&:to_sym)
  end

  def fetch_detail(id)
    detail_response_path.inject(detail_body(id)) do |result, key|
      result[key] || {}
    end
  end

  def detail_body(id)
    detail_response(id).body
  end

  def detail_operation
    @configuration.detail_operation.to_sym
  end

  def detail_response(id)
    @client.call(detail_operation, advanced_typecasting: false, message: detail_message(id))
  end

  def detail_message(id)
    default_message.merge({ id: id })
  end

  def import_real_state(attributes)
    begin
      update_real_state(real_state(attributes), fetch_detail(attributes[:id]))
    # rescues from detail fail request so we keep fetching
    rescue Savon::SOAPFault => e
      log(:error, I18n.t('services.importer.log.soap_fault', line: @line, error: e.to_s))
    end
  end
  # TODO END

  def real_state(attributes)
    find_or_initializer(Integration::RealStates::RealState, attributes)
  end

  def update_real_state(real_state, attributes)
    update_associations(real_state, attributes)
    update(real_state, attributes, @line)
  end

  def update_associations(real_state, attributes)
    real_state.manager =         Integration::Supports::Organ.find_by(sigla: safe_strip(attributes[:sigla_orgao]), orgao_sfp: false)
    real_state.property_type =   Integration::Supports::RealStates::PropertyType.find_or_create_by(title: safe_strip(attributes[:tipo_imovel]))
    real_state.occupation_type = Integration::Supports::RealStates::OccupationType.find_or_create_by(title: safe_strip(attributes[:tipo_ocupacao]))
  end

  def find_or_initializer(model, attributes)
    model.find_or_initialize_by(
      service_id: attributes[:id],
      municipio: attributes[:municipio]
    )
  end

  def message
    default_message.merge({
      pagina: @page,
      limite: PAGINATION_LIMIT
    })
  end

  def configuration_class
    Integration::RealStates::Configuration
  end
end

