class Integration::Outsourcing::Importer < Integration::Supports::BaseSupportsImporter

  IMPORT_CONFIGS = {
    consolidation:{
      resource_class: Integration::Outsourcing::Consolidation,
      resource_finder_params: [
        :mes
      ]
    },
    entity: {
      resource_class: Integration::Outsourcing::Entity,
      resource_finder_params: [
        :isn_entidade,
        :dsc_sigla,
        :dsc_entidade
      ]
    },
    monthly_cost: {
      resource_class: Integration::Outsourcing::MonthlyCost,
      resource_finder_params: [
        :numerocontrato,
        :competencia,
        :nome,
        :cpf,
        :orgao,
        :categoria,
        :data_inicio,
        :data_termino,
        :tipo_servico,
        :situacao,
        :dias_trabalhados,
        :qtd_hora_extra,
        :vlr_hora_extra,
        :qtd_diarias,
        :vlr_diarias,
        :vlr_vale_transporte,
        :vlr_vale_refeicao,
        :vlr_salario_base,
        :vlr_custo_total,
        :month_import,
        :isn_entidade,
        :vlr_adicional,
        :vlr_adicional_noturno,
        :vlr_reserva_tecnica,
        :vlr_encargos,
        :vlr_taxa,
        :vlr_cesta_basica,
        :vlr_farda,
        :vlr_municao,
        :vlr_seguro_vida,
        :vlr_supervisao,
        :vlr_insalubridade,
        :vlr_periculosidade,
        :vlr_equipamento,
        :vlr_tributos,
        :vlr_total_montante,
        :vlr_dsr,
        :vlr_extra_encargos,
        :vlr_extra_taxa,
        :vlr_extra_tributos,
        :vlr_total_extra,
        :vlr_passagem,
        :vlr_viagem,
        :vlr_viagem_taxa,
        :vlr_viagem_tributos,
        :vlr_total_viagem,
        :vlr_plano_saude,
        :vlr_outros,
        :remuneracao,
      ]
    }
  }

  REMUNERATION_FIELDS = [
    :vlr_salario_base,
    :vlr_adicional,
    :vlr_adicional_noturno,
    :vlr_insalubridade,
    :vlr_periculosidade,
    :vlr_vale_transporte,
    :vlr_vale_refeicao,
    :vlr_cesta_basica,
    :vlr_hora_extra,
    :vlr_dsr,
  ]

  #DPGE, CAGECE, CEGAS, CODECE, METROFOR,
  #ADECE, CEARAPORTOS, ADECE, COGERH, ZPE, CEASA,
  INVALID_ENTITIES = [
    'CAGECE',
    'DPGE',
    'CEGAS',
    'CODECE',
    'METROFOR',
    'ADECE',
    'CEARAPORTOS',
    'ADECE',
    'COGERH',
    'ZPECEARA',
    'CEASA',
  ]

  def configuration_class
    base_namespace::Configuration
  end

  def message(prefix)
    message_hash[prefix]
  end

  def message_hash
    {
      entity: {
        usuario: @configuration.user,
        senha: @configuration.password
      },
      monthly_cost: {
        usuario: @configuration.user,
        senha: @configuration.password,
        ano: @configuration.year_import,
        mes: @configuration.month_import.rjust(2, '0'),
        entidade: @entity_id,
        cpf: ''
      },
      consolidation: {
        usuario: @configuration.user,
        senha: @configuration.password
      }
    }
  end

  private

  def attributes_sanitize(kind, attributes)
    attributes[:month_import] = @configuration.month

    if kind == :entity
      attributes[:dsc_sigla] = attributes[:dsc_sigla].strip
    end

    if kind == :monthly_cost
      attributes[:orgao] = attributes[:orgao].strip
      attributes[:categoria] = attributes[:categoria] || resource_class.undefined_category
      attributes[:isn_entidade] = @entity_id
      attributes[:remuneracao] = attributes.select {|i|i.in? REMUNERATION_FIELDS}.values.map(&:to_d).sum
    end

    attributes
  end

  def base_namespace
    Integration::Outsourcing::MonthlyCosts
  end

  def category_klass
    Integration::Outsourcing::Category
  end

  def consolidation_klass
    Integration::Outsourcing::Consolidation
  end

  def competence_affeteds_for_service(service)
    for competence in months_affecteds
      service.call(
        competence_split(:year, competence),
        competence_split(:month, competence)
      )
    end
  end

  def create_spreadsheet
    competence_affeteds_for_service(
      base_namespace::CreateSpreadsheet
    )
  end

  def create_stats
    competence_affeteds_for_service(
      base_namespace::CreateStats
    )
  end

  def create_categories
    for categoria in monthly_cost_class.distinct.pluck(:categoria).each
      category_klass.find_or_create_by(description: categoria)
    end
  end

  def competence_split(type, competence)
    return competence.split('/').last.to_i if type == :year
    return competence.split('/').first.to_i if type == :month
  end

  def has_invalid_entity(attributes)
    INVALID_ENTITIES.include? attributes[:dsc_sigla]
  end

  def import
    start

    begin

      ApplicationDataRecord.transaction do
        import_from(:consolidation)
        import_from(:entity)
        for entity_id in imported_entities_ids
          @entity_id = entity_id
          import_from(:monthly_cost)
        end
      end

      create_stats
      create_spreadsheet
      create_categories

      close_log
      @configuration.status_success!

    rescue StandardError => e
      log(:error, I18n.t('services.importer.log.error', e: e.message))
      close_log
      @configuration.status_fail!
    end
  end

  def importer_id
    :outsorcing
  end

  def import_from(kind)
    
    @resource_class = IMPORT_CONFIGS[kind][:resource_class]

    line = 0
    organ = ''
    
    resources(kind).each do |attributes|
      line += 1
      attributes = attributes_sanitize(kind, attributes)
      organ = attributes[:orgao] if kind == :monthly_cost
      next if kind == :entity and has_invalid_entity(attributes)

      import_resource(attributes, line)
    end
    log(:info, I18n.t("services.importer.log.#{kind}", line: line, organ: organ)) if line >0
  end

  def imported_entities_ids
    resource_class.select(:isn_entidade).pluck(:isn_entidade)
  end

  def months_affecteds
    resource_class.distinct
      .where(
        "updated_at >= ? and updated_at < ?",
        Time.current.beginning_of_day,
        Time.current.end_of_day
      )
      .pluck(:competencia)
  end

  def monthly_cost_class
    IMPORT_CONFIGS[:monthly_cost][:resource_class]
  end

  def resource_class
    @resource_class #ela muda de valor
  end

  def resource_class_sym
    resource_class.name.demodulize.underscore.to_sym
  end


  def resource_finder_params(attributes)
    finder_params = IMPORT_CONFIGS[resource_class_sym][:resource_finder_params]

    resource_finder_params = finder_params.inject({}) do |result, param_name|
      param = attributes[param_name]
      param = param.strip if param.is_a? String

      result[param_name] = param
      result
    end
  end

  # update! foi sobrescrito pois durante o safe_assign_attributes,
  # ele pega o resource e reatribui os valores dos attributos
  # e neste caso existe um strip removendo os espaços dos atributos após
  # setar o seu valor no resource.

  def update!(resource, attributes)
    #safe_assign_attributes(resource, attributes)
    if resource.class == consolidation_klass
      mes = attributes[:mes]
      attributes[:month] = mes[2..3]
      attributes[:year] = mes[4..7]
      super(resource, attributes)
    else
      resource.save!
    end
  end
end
