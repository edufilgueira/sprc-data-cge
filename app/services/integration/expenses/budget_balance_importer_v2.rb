class Integration::Expenses::BudgetBalanceImporterV2
	include LogImporter

	attr_accessor :started_at, :finished_at, :configuration, :logger, :current_import_month_year


	IMPORT_CONFIGS = {
		budget_balance: {
      resource_class: Integration::Expenses::BudgetBalance,
      etl_integration_class: EtlIntegration::BudgetBalance,
      resource_finder_params: [ :ano_mes_competencia, :classif_orcam_reduz ]
    }
	}

	def self.call(configuration_id)
		new(configuration_id).call
	end

	def initialize(configuration_id)
    @configuration = configuration_class.find(configuration_id)
    @started_at = configuration.started_at
    @finished_at = configuration.finished_at

    raise 'Não pode importar anos diferentes. Veja o período pesquisado.' if started_at.year != finished_at.year
  end

	def call
		start
   	import
    create_stats
    create_spreadsheets
    close_log
  end

	def import
		IMPORT_CONFIGS.keys.each do |domain|      
      months_to_import.each do |month_year|
        current_import_month_year = month_year
  			etl_integration_class(domain)
        .where(nummes: month_year.split('-')[0])
        .find_each(batch_size: 500) do |record|
				  import_resource(domain, record.attributes)
  			end
      end
		end
	end

	def import_resource(domain, attributes)
    resource_class = resource_class(domain)

    attributes = change_from_to(domain, attributes)
    
    resource = resource_class.find_or_initialize_by(params_to_finder(domain, attributes))

    update(resource, attributes)
  end

  def update(resource, attributes)
    begin
      update! resource, attributes
    rescue => err
      log(:error, I18n.t('services.importer.log.validation_fail', line: '', error: resource.errors.full_messages.to_sentence))
    end
  end

  def update!(resource, attributes)
    safe_assign_attributes(resource, attributes)
    resource.save! if resource.changed? || resource.new_record?
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
    current_month = finished_at.month
    year = finished_at.year
    #
    # importando as combinações de períodos mensal dentro de um determinado ano
    #    
    
    (1..current_month).each do |month_start|
      month_range = { month_start: month_start, month_end: current_month }

      service_klass.call(year, 0, month_range)
    end
    
  end

	private

	def configuration_class
    Integration::Expenses::Configuration
  end

	def resource_class(domain)
		IMPORT_CONFIGS[domain][:resource_class]
	end

	def etl_integration_class(domain)
		IMPORT_CONFIGS[domain][:etl_integration_class]
	end

	def resource_finder_params(domain)
		IMPORT_CONFIGS[domain][:resource_finder_params]
	end

	def params_to_finder(domain, attributes)
    attributes['ano_mes_competencia'] = "#{attributes['nummes'].to_s.rjust(2, '0')}-#{attributes['numano']}"
    resource_finder_params = resource_finder_params(domain).inject({}) do |result, param_name|
      result[param_name] = attributes[param_name] || attributes[param_name.to_s]
      result
    end
  end

  def change_from_to(domain, attributes)
  	attributes.transform_keys do |key| 
      etl_integration_class(domain).from_to[key] || key 
    end
  end

  def safe_assign_attributes(resource, attributes)
    #
    # Temos que garantir que se houver adição de colunas no webservice, o
    # importador não irá falhar ao tentar atribuir seu valor, como quando usado
    # o update_attributes, ou o assign_attributes.
    #
    attributes.delete('id')
    attributes['data_atual'] = Date.today

    attributes.each do |name, value|
      if resource.respond_to?("#{name}=")
        resource.send("#{name}=", value)
      end
    end
  end

  def months_to_import(rjust=nil)
    (@started_at..@finished_at).map do |d| 
      month = rjust ? d.month.to_s.rjust(2, '0') : d.month
      "#{month}-#{d.year}"
    end.uniq
  end

  def stats_month_years
    start_date = @started_at
    end_date = @finished_at

    (start_date..end_date).collect do |date|
      month = (stats_yearly? ? 0 : date.month)
      [month, date.year]
    end.uniq
  end

  # Define se a estatística é anual, como no caso das 'Despesas do poder executivo'
  def stats_yearly?
    false
  end

  def create_stats_klass
    Integration::Expenses::BudgetBalances::CreateStats
  end

  def create_spreadsheet_klass
    Integration::Expenses::BudgetBalances::CreateSpreadsheet
  end
end 