class Integration::Supports::Domain::ImporterV2
	include LogImporter

	attr_accessor :year, :configuration, :logger


	IMPORT_CONFIGS = {
    administrative_region: {
      resource_class: Integration::Supports::AdministrativeRegion,
      etl_integration_class: EtlIntegration::AdministrativeRegion,
      resource_finder_params: [ :codigo_regiao ]
    },
    government_action: {
      resource_class: Integration::Supports::GovernmentAction,
      etl_integration_class: EtlIntegration::GovernmentAction,
      resource_finder_params: [ :codigo_acao ]
    },

    government_program: {
      resource_class: Integration::Supports::GovernmentProgram,
      etl_integration_class: EtlIntegration::GovernmentProgram,
      resource_finder_params: [ :codigo_programa ]
    },
    economic_category: {
      resource_class: Integration::Supports::EconomicCategory,
      etl_integration_class: EtlIntegration::EconomicCategory,
      resource_finder_params: [ :codigo_categoria_economica ]
    },
  
    resource_source: {
      resource_class: Integration::Supports::ResourceSource,
      etl_integration_class: EtlIntegration::ResourceSource,
      resource_finder_params: [ :codigo_fonte ]
    },
    function: {
      resource_class: Integration::Supports::Function,
      etl_integration_class: EtlIntegration::Function,
      resource_finder_params: [ :codigo_funcao ]
    },
    sub_function: {
      resource_class: Integration::Supports::SubFunction,
      etl_integration_class: EtlIntegration::SubFunction,
      resource_finder_params: [ :codigo_sub_funcao ]
    },

    expense_nature_group: {
      resource_class: Integration::Supports::ExpenseNatureGroup,
      etl_integration_class: EtlIntegration::ExpenseNatureGroup,
      resource_finder_params: [ :codigo_grupo_natureza ]
    },

    expense_nature: {
      resource_class: Integration::Supports::ExpenseNature,
      etl_integration_class: EtlIntegration::ExpenseNature,
      resource_finder_params: [ :codigo_natureza_despesa ]
    },

    revenue_nature: {
      resource_class: Integration::Supports::RevenueNature,
      etl_integration_class: EtlIntegration::RevenueNature,
      resource_finder_params: [ :codigo ] 
    },

    application_modalitie: {
      resource_class: Integration::Supports::ApplicationModality,
      etl_integration_class: EtlIntegration::ApplicationModality,
      resource_finder_params: [ :codigo_modalidade ]
    },     
    payment_retention_type: {
      resource_class: Integration::Supports::PaymentRetentionType,
      etl_integration_class: EtlIntegration::PaymentRetentionType,
      resource_finder_params: [ :codigo_retencao ]
    }, 
    product: {
      resource_class: Integration::Supports::Product,
      etl_integration_class: EtlIntegration::Product,
      resource_finder_params: [ :codigo ]
    },

    legal_device: {
      resource_class: Integration::Supports::LegalDevice,
      etl_integration_class: EtlIntegration::LegalDevice,
      resource_finder_params: [ :codigo]
    },

    creditor: {
      resource_class: Integration::Supports::Creditor,
      etl_integration_class: EtlIntegration::Creditor,
      resource_finder_params: [ :cpf_cnpj ]      
    }  
     
  }

	def self.call(configuration_id)
		new(configuration_id).call
	end

	def initialize(configuration_id)
    @configuration = configuration_class.find(configuration_id)
    @year = configuration.year
    @logger = Logger.new(log_path) if @logger.nil?

  end

	def call
		start
   	import
    close_log
  end

	def import

		IMPORT_CONFIGS.keys.each do |domain|
			etl_integration_class(domain).find_each(batch_size: 500) do |record|
				import_resource(domain, record.attributes)
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

	private

	def configuration_class
    Integration::Supports::Domain::Configuration
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
    resource_finder_params = resource_finder_params(domain).inject({}) do |result, param_name|
      result[param_name] = attributes[param_name] || attributes[param_name.to_s]
      result
    end
  end

  def change_from_to(domain, attributes)
  	attributes.transform_keys{|key| etl_integration_class(domain).from_to[key.to_sym] || key }
  end

  def safe_assign_attributes(resource, attributes)
    #
    # Temos que garantir que se houver adição de colunas no webservice, o
    # importador não irá falhar ao tentar atribuir seu valor, como quando usado
    # o update_attributes, ou o assign_attributes.
    #

    attributes.delete('id')
    attributes.each do |name, value|
      if resource.respond_to?("#{name}=")
        resource.send("#{name}=", value)
      end
    end
  end
end 