class Integration::Expenses::BaseExpensesImporter
  include BaseIntegrationsImporter

  attr_reader :configuration, :logger, :client, :started_at, :finished_at

  def self.call(configuration, logger)
    new(configuration, logger).call
  end

  def initialize(configuration, logger)
    @configuration = configuration
    @logger = logger

    # Precisamos guardar o valor do mês antes, e não depender mais do
    # configuration, para permitir que outros processo de
    # importação rodem paralelo e que as estatísticas/planilhas, criadas no
    # final do processo, sejam geradas com a data esperada.

    @started_at, @finished_at = dates_from_configuration

    @client = client_connection(wsdl, headers_soap_action)
  end

  def call
    # Ex: import(:ned), import(:npf), import(:nld), ...
    import(importer_id)

    create_stats
    create_spreadsheets
  end

  protected

  def import(kind)

    line = 0

    resources(kind).each do |attributes|
      line += 1

      send("import_#{kind}", attributes, line)

    end

    log(:info, I18n.t("services.importer.log.#{kind}", line: line))

  end

  def find_or_initializer(model, attributes)
    model.find_or_initialize_by(
      exercicio: attributes[:exercicio],
      unidade_gestora: attributes[:unidade_gestora],
      numero: attributes[:numero])
  end

  def list_attributes(list)
    attributes = list.first.second
    attributes.is_a?(Hash) ? [attributes] : attributes
  end

  def message(kind)
    {
      usuario: @configuration.send("#{kind}_user"),
      senha: @configuration.send("#{kind}_password"),
      data_inicio: started_at.to_s,
      data_fim: finished_at.to_s
    }
  end

  private

  def importer_id
    model_klass.model_name.element
  end

  def wsdl
    @configuration.send("#{importer_id}_wsdl")
  end

  def headers_soap_action
    @configuration.send("#{importer_id}_headers_soap_action")
  end

  def create_stats
    # Permite desabilitar a geração de estatísticas, para os casos que estamos
    # importando dados legados pois estatística é anual e os dados são carregados
    # a cada poucos dias.
    unless ENV['BYPASS_STATS'] == 'true'
      classes = (create_stats_klass.is_a?(Array) ? create_stats_klass : [create_stats_klass])
      classes.each do |klass|
        call_service_for_each_month_year(klass)
      end
    end
  end

  def create_spreadsheets
    # Permite desabilitar a geração de planilhas, para os casos que estamos
    # importando dados legados pois a planilha é anual e os dados são carregados
    # a cada poucos dias.
    unless ENV['BYPASS_SPREADSHEETS'] == 'true'
      classes = (create_spreadsheet_klass.is_a?(Array) ? create_spreadsheet_klass : [create_spreadsheet_klass])
      classes.each do |klass|
        call_service_for_each_month_year(klass)
      end
    end
  end

  def call_service_for_each_month_year(service_klass)
    return if service_klass.blank?

    stats_month_years.each do |month, year|
      service_klass.call(year, month)
    end
  end

  def create_spreadsheet_klass
    nil
  end

  # Define se a estatística é anual, como no caso das 'Despesas do poder executivo'
  def stats_yearly?
    false
  end

  def month_years
    start_date = started_at
    end_date = finished_at

    (start_date..end_date).collect do |date|
      [date.month, date.year]
    end.uniq
  end

  def stats_month_years
    start_date = started_at
    end_date = finished_at

    (start_date..end_date).collect do |date|
      month = (stats_yearly? ? 0 : date.month)
      [month, date.year]
    end.uniq
  end

  def for_each_month_year
    month_years.each do |month_year|
      month = month_year[0]
      year = month_year[1]

      yield(month, year)
    end
  end

  #
  # Atenção: esse método é chamado apenas na inicialização do serviço. Para
  # referenciar o período corrente use 'started_at' e 'finished_at'.
  #
  def dates_from_configuration
    @dates_from_configuration ||= [
      @configuration.started_at.present? ? @configuration.started_at.to_date : Date.yesterday,
      @configuration.finished_at.present? ? @configuration.finished_at.to_date : Date.yesterday
    ]
  end
end
