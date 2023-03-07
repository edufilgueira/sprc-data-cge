class Integration::Contracts::DailyUpdater < Integration::Contracts::Importer

  CONTRACT_CLASSES = {
    contract: Integration::Contracts::Contract,
    additive: Integration::Contracts::Additive,
    adjustment: Integration::Contracts::Adjustment,
    financial: Integration::Contracts::Financial
  }

  SERVICE_CONFIGURATION = {
    response_path: {
      contract: 'consulta_contratos_convenios_atualizados_response/lista_contratos_convenios_atualizados/contrato_convenio',
      additive: 'consulta_aditivos_atualizados_response/lista_aditivos_atualizados/aditivo',
      adjustment: 'consulta_apostilamentos_atualizados_response/lista_apostilamentos_atualizados/apostilamento',
      financial: 'consulta_financeiros_atualizados_response/lista_financeiros_atualizados/financeiro',
      infringement: 'consulta_inadimplencia_response/lista_inadimplencia/inadimplencia'
    },

    operation: {
      contract: :consulta_contratos_convenios_atualizados,
      additive: :consulta_aditivos_atualizados,
      adjustment: :consulta_apostilamentos_atualizados,
      financial: :consulta_financeiros_atualizados,
      infringement: :consulta_inadimplencia
    },

    parameter: {
      contract: 'dataInstrumento=DATE',
      additive: 'dataAditivo=DATE',
      adjustment: 'dataAjuste=DATE',
      financial: 'dataDocumento=DATE',
      infringement: ''
    }
  }

  attr_accessor :date, :dates_for_update

  def initialize(configuration_id, date = nil)
    # Data base passada como parâmetro
    @date = date_for_update(date)

    # Data para cada recurso.
    @dates_for_update = dates_for_update(@date)

    super(configuration_id)
  end

  def self.call(configuration_id, date = nil)
    new(configuration_id, date).call
  end

  def call
    start # temos que chamar o start por conta do log!

    import_data
  end

  private

  def import(kind)
    log(:info, "[CONTRACTS][DAILY_UPDATER] - Atualização diária de #{kind} iniciando a partir de: #{date_str(kind)}")

    super
  end

  def response_path(prefix)
    SERVICE_CONFIGURATION[:response_path][prefix].split('/').map(&:to_sym)
  end

  def operation(prefix=nil)
    SERVICE_CONFIGURATION[:operation][prefix]
  end

  def message(prefix)
    msg = SERVICE_CONFIGURATION[:parameter][prefix]
    default_message.merge(message_underscore(msg, prefix))
  end

  def message_without_placeholder(msg = "", prefix)
     msg.gsub('DATE', date_str(prefix))
  end

  def date_str(prefix)
    return '' if @dates_for_update[prefix].blank?

    parse_date(@dates_for_update[prefix])
  end

  def date_for_update(date)
    if date == nil
      Date.today - 1.day
    else
      date
    end
  end

  def dates_for_update(default_date)
    dates = {}

    CONTRACT_CLASSES.keys.each do |class_id|
      model = CONTRACT_CLASSES[class_id]

      last = model.where.not(data_auditoria: nil).order('data_auditoria DESC').first

      if last.blank? || last.data_auditoria.blank?
        dates[class_id] = default_date
      else
        dates[class_id] = last.data_auditoria
      end
    end

    dates
  end
end
