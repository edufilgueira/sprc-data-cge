#
# Importador de dados do ETL Integração
#
class Integration::Expenses::NedImporterV2
	include LogImporter

	attr_accessor :started_at, :finished_at, :configuration, :logger, :current_import_month_year

  NAMESPACES = %w{
	  Integration::Expenses::Neds
	  Integration::Expenses::Dailies
	  Integration::Expenses::CityTransfers
	  Integration::Expenses::ProfitTransfers
	  Integration::Expenses::NonProfitTransfers
	  Integration::Expenses::MultiGovTransfers
	  Integration::Expenses::ConsortiumTransfers
	  Integration::Expenses::FundSupplies
	}

	IMPORT_CONFIGS = {
		budget_balance: {
      resource_class: Integration::Expenses::Ned,
      etl_integration_class: EtlIntegration::ExpensesNed,
      resource_finder_params: [ :exercicio, :unidade_gestora, :numero ]
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
    # create_stats
    # create_spreadsheets
    close_log
  end

	private

	def import
		IMPORT_CONFIGS.keys.each do |domain|      
      months_to_import.each do |month_year|
        current_import_month_year = month_year
  			etl_integration_class(domain)
        .where("dataemissao between ? and ? ", started_at, finished_at.to_datetime.end_of_day )
        .find_each(batch_size: 500) do |record|
				  import_resource(domain, record.attributes)
  			end
      end
		end
	end

  def import_resource(domain, attributes)
  	import_ned(domain, attributes)
  end

  def import_ned(domain, attributes)
  	
    return if attributes.blank?

    resource_class = resource_class(domain)

    attributes = change_from_to(domain, attributes)
    
    resource = resource_class.find_or_initialize_by(params_to_finder(domain, attributes))
    
    # Remover itens vinculados
    # items_ned, items_planning, items_disbursement_forecast
    #
    # deleted_lists_attributes = remove_lists_attributes(attributes)

    update(resource, attributes)

    #update_lists(ned, deleted_lists_attributes)
  end

  def model_klass
    Integration::Expenses::Ned
  end

  def create_stats_klass
    Integration::Expenses::Neds::CreateStats
  end

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

  def create_stats
    unless ENV['BYPASS_STATS'] == 'true'
      years.each do |year|
        NAMESPACES.each do |namespace|
          logger.info("[EXPENSES] - Gerando estatísticas para #{namespace} [#{year}].")
          stats_service_class = "#{namespace}::CreateStats".constantize
          stats_service_class.call(year, 0)
        end
      end
    end
  end

  def create_spreadsheets
    unless ENV['BYPASS_SPREADSHEETS'] == 'true'
      years.each do |year|
        NAMESPACES.each do |namespace|
          logger.info("[EXPENSES] - Gerando planilhas para #{namespace} [#{year}].")
          spreadsheets_service_class = "#{namespace}::CreateSpreadsheet".constantize
          spreadsheets_service_class.call(year, 0)
        end
      end
    end
  end


  # def update_lists(ned, attributes)
  #   destroy_lists(ned)
  #   create_items(ned, attributes[:items_ned]) if attributes[:items_ned].present?
  #   create_planning_items(ned, attributes[:items_planning]) if attributes[:items_planning].present?
  #   create_disbursement_forecasts(ned, attributes[:items_disbursement_forecast]) if attributes[:items_disbursement_forecast].present?
  # end

  # def remove_lists_attributes(attributes)
  #   {
  #     items_ned: attributes.delete(:lista_itens_ned),
  #     items_planning: attributes.delete(:lista_itens_planejamento_empenho),
  #     items_disbursement_forecast: attributes.delete(:lista_previsoes_desembolso)
  #   }
  # end

  # def destroy_lists(ned)
  #   ned.ned_items.delete_all
  #   ned.ned_planning_items.delete_all
  #   ned.ned_disbursement_forecasts.delete_all
  # end

  # def create_items(ned, items)
  #   list_attributes(items).each do |attributes|
  #     ned.ned_items << Integration::Expenses::NedItem.create(attributes)
  #   end
  # end

  # def create_planning_items(ned, plannning_items)
  #   list_attributes(plannning_items).each do |attributes|
  #     ned.ned_planning_items << Integration::Expenses::NedPlanningItem.create(attributes)
  #   end
  # end

  # def create_disbursement_forecasts(ned, disbursement_forecasts)
  #   list_attributes(disbursement_forecasts).each do |attributes|
  #     ned.ned_disbursement_forecasts << Integration::Expenses::NedDisbursementForecast.create(attributes)
  #   end
  # end

  def years
    month_years.map{|ym| ym[1]}.uniq
  end

  # Define se a estatística é anual
  def stats_yearly?
    true
  end

  def months_to_import(rjust=nil)
    (@started_at..@finished_at).map do |d| 
      month = rjust ? d.month.to_s.rjust(2, '0') : d.month
      "#{month}-#{d.year}"
    end.uniq
  end

  def change_from_to(domain, attributes)
    attributes.transform_keys do |key| 
      etl_integration_class(domain).from_to[key] || key 
    end
  end

  def params_to_finder(domain, attributes)
    attributes['exercicio'] = "2022"
    resource_finder_params = resource_finder_params(domain).inject({}) do |result, param_name|
      result[param_name] = attributes[param_name] || attributes[param_name.to_s]
      result
    end
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

  def safe_assign_attributes(resource, attributes)
    #
    # Temos que garantir que se houver adição de colunas no webservice, o
    # importador não irá falhar ao tentar atribuir seu valor, como quando usado
    # o update_attributes, ou o assign_attributes.
    #
    attributes.delete('id')
    attributes.delete('created_at')
    attributes.delete('updated_at')
    attributes.delete('data_atual')
    attributes['valor_pago'] = 0
    #attributes['classificacao_orcamentaria_completo'] = attributes['classificacao_orcamentaria_completo'].delete(' ').delete('.')
    
    attributes.each do |name, value|
      if resource.respond_to?("#{name}=")
        resource.send("#{name}=", value)
      end
    end
  end


end
