class Integration::Supports::Domain::Importer < Integration::Supports::BaseSupportsImporter

  IMPORT_CONFIGS = {

    administrative_region: {
      response_path: 'lista_regiao_administrativa/regiao_administrativa',
      resource_class: Integration::Supports::AdministrativeRegion,
      resource_finder_params: [ :codigo_regiao ]
    },

    government_program: {
      response_path: 'lista_programa_governo/programa_governo',
      resource_class: Integration::Supports::GovernmentProgram,
      resource_finder_params: [ :ano_inicio, :codigo_programa ]
    },

    government_action: {
      response_path: 'lista_acao_governamental/acao_governamental',
      resource_class: Integration::Supports::GovernmentAction,
      resource_finder_params: [ :codigo_acao ]
    },

    product: {
      response_path: 'lista_produto/produto',
      resource_class: Integration::Supports::Product,
      resource_finder_params: [ :codigo ]
    },

    sub_product: {
      response_path: 'lista_sub_produto/sub_produto',
      resource_class: Integration::Supports::SubProduct,
      resource_finder_params: [ :codigo, :codigo_produto ]
    },

    function: {
      response_path: 'lista_funcao/funcao',
      resource_class: Integration::Supports::Function,
      resource_finder_params: [ :codigo_funcao ]
    },

    sub_function: {
      response_path: 'lista_sub_funcao/sub_funcao',
      resource_class: Integration::Supports::SubFunction,
      resource_finder_params: [ :codigo_sub_funcao ]
    },

    finance_type: {
      response_path: 'lista_tipo_despesa/tipo_despesa',
      resource_class: Integration::Supports::ExpenseType,
      resource_finder_params: [ :codigo ]
    },

    payment_retention_type: {
      response_path: 'lista_tipo_retencao_pagamento/tipo_retencao_pagamento',
      resource_class: Integration::Supports::PaymentRetentionType,
      resource_finder_params: [ :codigo_retencao ]
    },

    management_unit: {
      response_path: 'lista_unidade_gestora/unidade_gestora',
      resource_class: Integration::Supports::ManagementUnit,
      resource_finder_params: [ :codigo ]
    },

    budget_unit: {
      response_path: 'lista_unidade_orcamentaria/unidade_orcamentaria',
      resource_class: Integration::Supports::BudgetUnit,
      resource_finder_params: [ :codigo_unidade_orcamentaria ]
    },

    revenue_nature: {
      response_path: 'lista_natureza_receita/natureza_receita',
      resource_class: Integration::Supports::RevenueNature,
      resource_finder_params: [ :codigo, :year ]
    },

    expense_nature: {
      response_path: 'lista_natureza_despesa/natureza_despesa',
      resource_class: Integration::Supports::ExpenseNature,
      resource_finder_params: [ :codigo_natureza_despesa ]
    },

    expense_nature_item: {
      response_path: 'lista_item_natureza_despesa/item_natureza_despesa',
      resource_class: Integration::Supports::ExpenseNatureItem,
      resource_finder_params: [ :codigo_item_natureza ]
    },

    expense_nature_group: {
      response_path: 'lista_grupo_natureza_despesa/grupo_natureza_despesa',
      resource_class: Integration::Supports::ExpenseNatureGroup,
      resource_finder_params: [ :codigo_grupo_natureza ]
    },

    finance_nature_group: {
      response_path: 'lista_grupo_financeiro/grupo_financeiro',
      resource_class: Integration::Supports::FinanceGroup,
      resource_finder_params: [ :codigo_grupo_financeiro ]
    },

    application_modality: {
      response_path: 'lista_modalidade_aplicacao/modalidade_aplicacao',
      resource_class: Integration::Supports::ApplicationModality,
      resource_finder_params: [ :codigo_modalidade ]
    },

    resource_source: {
      response_path: 'lista_fonte_recurso/fonte_recurso',
      resource_class: Integration::Supports::ResourceSource,
      resource_finder_params: [ :codigo_fonte, :titulo ]
    },

    qualified_resource_source: {
      response_path: 'lista_fonte_recurso_qualificada/fonte_recurso_qualificada',
      resource_class: Integration::Supports::QualifiedResourceSource,
      resource_finder_params: [ :codigo ]
    },

    legal_device: {
      response_path: 'lista_dispositivo_legal/dispositivo_legal',
      resource_class: Integration::Supports::LegalDevice,
      resource_finder_params: [ :codigo ]
    },

    economic_category: {
      response_path: 'lista_categoria_economica/categoria_economica',
      resource_class: Integration::Supports::EconomicCategory,
      resource_finder_params: [ :codigo_categoria_economica ]
    },

    expense_element: {
      response_path: 'lista_elemento_despesa/elemento_despesa',
      resource_class: Integration::Supports::ExpenseElement,
      resource_finder_params: [ :codigo_elemento_despesa ]
    }
  }

  private

  def importer_id
    :domain
  end

  def configuration_class
    Integration::Supports::Domain::Configuration
  end

  def import
    start

    begin
      IMPORT_CONFIGS.keys.each do |kind|
        ApplicationDataRecord.transaction do
          import_from(kind)
        end
      end

      log(:info, I18n.t("services.importer.log.#{importer_id}"))
      close_log
      @configuration.status_success!

    rescue StandardError => e
      log(:error, I18n.t('services.importer.log.error', e: e.message))
      close_log
      @configuration.status_fail!
    end

  end

  def import_from(kind)
    line = 0

    resources(kind).each do |attributes|
      line += 1

      import_resource(kind, attributes, line)
    end

    if kind == :revenue_nature
      update_revenue_nature_unique_ids
    end
  end

  def import_resource(kind, attributes, line)
    resource_class = IMPORT_CONFIGS[kind][:resource_class]

    resource = resource_class.find_or_initialize_by(resource_finder_params(kind, attributes))

    update(resource, attributes, line)
  end

  def body(prefix=nil)
    # Cacheia a resposta pois em 1 requisição já temos todos os dados.

    return @body if @body.present?

    # o prefix é usado em alguns importers como revenues, ...
    selected_response = (prefix.present? ? response(prefix) : response)

    @body = selected_response.present? ? selected_response.body : {}

    @body
  end

  def message
    {
      usuario: @configuration.user,
      senha: @configuration.password,
      exercicio: year
    }
  end

  def year
    @configuration.year.present? ? @configuration.year : Date.today.year
  end

  def resources(kind)

    response_path = IMPORT_CONFIGS[kind][:response_path].split('/').map(&:to_sym)
    tabela_exercicio = body[:consulta_tabela_exercicio_response][:tabela_exercicio]

    result_array = response_path.inject(tabela_exercicio) do |result, key|
      result[key] || {}
    end

    result_array = result_array.map{|i| i.merge({:year => tabela_exercicio[:ano_exercicio]})}
    ensure_resource_type(result_array)
  end

  def resource_finder_params(kind, attributes)
    resource_finder_params = IMPORT_CONFIGS[kind][:resource_finder_params].inject({}) do |result, param_name|
      result[param_name] = attributes[param_name]
      result
    end
  end

  # Temos que passar por cada revenue_nature_type para atualizar seus unique_ids
  def update_revenue_nature_unique_ids
    types = Integration::Supports::RevenueNature.revenue_nature_types.keys
    types.each do |type|
      revenue_natures = Integration::Supports::RevenueNature.send(type)
      revenue_natures.each {|r| r.valid? r.save}
    end
  end
end
