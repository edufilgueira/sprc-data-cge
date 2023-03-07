class Integration::BaseCreateStats

  attr_accessor :year, :month, :month_start, :month_end

  def self.call(year, month, month_range = nil)
    new(year, month, month_range).call
  end

  def initialize(year, month, month_range = nil)
    @year = year
    @month = month

    if month_range.present?
      @month_start = month_range[:month_start]
      @month_end = month_range[:month_end]
    end
  end

  #
  # O call padrão vai percorrer cada stat_group definido via STATS_GROUPS e
  # invocar os métodos "stats_for_#{nome_do_grupo}".
  #
  def call

    # Para usar o cache de queries do ActiveRecord. O mesmo usado nas
    # requisições.
    ApplicationRecord.cache do
      stats.data = Hash[stats_groups.map do |stats_group|
        [stats_group, send("stats_for_#{stats_group}")]
      end]

      stats.save
    end
  end

  #
  # Para as estatísticas de coluna, evita que implementemos os
  # 'stats_for_nome_da_coluna' e apenas temos que adicionar a coluna no
  # STATS_GROUPS do serviço.
  def method_missing(method_name, *args, &block)
    method_name_str = method_name.to_s

    if method_name_str.start_with?('stats_for_')
      column_name = method_name_str.gsub(/^stats_for_/,'')

      if stats_groups.include?(column_name.to_sym)
        return stats_for_column(column_name)
      end
    end

    super(method_name, args, block)
  end

  private

  def stats_for_total
    sum_for_scope(scope)
  end

  #
  # Soma as estatíticas agrupando pela coluna determinada e retorna um Hash
  # em que a chave é cada série estatística (do gráfico) e o valor é um
  # outro Hash contendo { nome_da_coluna_de_soma_1: 123.12, ..., count: 2}
  #
  # Ex de um Hash de estatística de Notas de Empenho (NED):
  # {
  #   valor: 123,20,
  #   valor_pago: 100,20,
  #   count: 2
  # }
  #
  #
  def stats_for_column(column_name)
    sums = {}

    sum_columns.each do |sum_column|

      # faz a some de cada coluna contabilizada, como por ex:
      #
      # sums[:valor] = scope.group(:razao_social_credor).sum(:valor)
      #
      # => {nil=>0.1e3, "CREDOR 1"=>0.2 e3, "CREDOR 2"=> ...}
      # (Hash em que a chave é cada grupo e o valor a soma de determinada coluna)
      #
      sums[sum_column] = scope.group(column_name).sum(sum_column)
      sums[:count] = scope.group(column_name).count
    end

    # Precisamos inverter o Hash de algo como { valor: { 'CREDOR'=> 10 } } para
    # algo como { 'CREDOR' => { valor: 10} } pois é esperado um hash em que a
    # chave seja cada séria do gráfico.

    result = reverse_sum_hash(sums)

    # Adiciona a contabilização dos valores não definidos
    result[I18n.t('messages.content.undefined')] = sum_for_scope(scope.where(column_name => nil))

    result
  end

  def reverse_sum_hash(sums)
    result = {}

    sums.each do |column_name, sum_data|
      # Cada sum tem a chave a coluna que foi somada e o valor as somas, como
      # por ex: {:valor=>{nil=>0.5e3, "CREDOR"=>0.1e4}, :valor_pago=>{nil=>0.1e3, "CREDOR"=>0.2e3}, :count=>...}

      sum_data.each do |item_name, sum_value|
        result[item_name] = {} if result[item_name].blank?

        result[item_name][column_name] = sum_value
      end
    end

    result
  end

  #
  # Retorna a estatística para associações, usando o 'resource_key' como chave
  # do Hash que será retornado.
  #
  # Ex: stats_for_association(:management_unit, management_units, :sigla)
  # => Irá calcular as estatística de management_units usando sua sigla como
  # chave para a série.
  #
  def stats_for_association(association_name, resource_key, full_column_name=nil, resource_column_value_name=nil)
    result = {}

    resources = unique_resources(association_name, full_column_name)

    resources.each do |resource|

      column_value = resource

      if resource_column_value_name.present?
        column_value = resource.send(resource_column_value_name)
      end

      scope = resources_for(association_name, column_value, full_column_name)

      # ex: managment_unit.sigla
      key = resource.send(resource_key)
      title = resource.try(:title) || key

      result[key] = sum_for_scope(scope).merge({title: title})
    end

    result[I18n.t('messages.content.undefined')] = sum_for_scope(resources_for(association_name, nil, full_column_name, resource_column_value_name))

    result
  end

  def reflection_for_association(association_name)
    scope.reflect_on_association(association_name).source_reflection
  end

  def unique_resources_ids(association_name, full_column_name=nil)
    reflection_info = reflection_info(association_name)
    key = reflection_info[:scope_key]

    table_name = scope.table_name
    distinct_name = (full_column_name.present? ? full_column_name : "#{table_name}.#{key}")

    distinct = "DISTINCT #{distinct_name}"

    scope.joins(association_name).pluck(distinct)
  end

  def unique_resources(association_name, full_column_name=nil)
    reflection_info = reflection_info(association_name)
    key = reflection_info[:association_key]

    ids = unique_resources_ids(association_name, full_column_name)
    association_model = reflection_info[:association_model]

    association_model.where("#{key} IN (?)", ids)
  end

  def reflection_info(association_name)
    reflection = reflection_for_association(association_name)
    association_model = reflection.class_name.constantize
    primary_key = (reflection.options[:primary_key] || association_model.primary_key)
    foreign_key = reflection.foreign_key

    association_key = (reflection.is_a?(ActiveRecord::Reflection::HasOneReflection) ? foreign_key : primary_key)
    scope_key = (reflection.is_a?(ActiveRecord::Reflection::HasOneReflection) ? primary_key : foreign_key)

    {
      association_model: association_model,
      primary_key: primary_key,
      foreign_key: foreign_key,
      association_key: association_key,
      scope_key: scope_key
    }
  end

  def resources_for(column_name, column_value, full_column_name=nil, resource_column_value_name=nil)
    column = (full_column_name.present? ? full_column_name : column_name)

    if resource_column_value_name.present?
      ids = unique_resources_ids(column_name, full_column_name)
      scope.where("#{column} NOT IN (?)", ids).includes(column_name).references(column_name)
    else
      scope.where(column => column_value).includes(column_name).references(column_name)
    end
  end

  #
  # Faz a soma de cada coluna somável de acordo com o scope passado.
  #
  def sum_for_scope(scope)
    result = Hash[sum_columns.map do |sum_column|
      [sum_column, scope.sum(sum_column).to_f]
    end]

    result[:count] = scope.distinct.count

    result
  end

  def stats
    @stats ||= stats_klass.find_or_initialize_by(finder_params)
  end

  def finder_params
    params = {
      month: month,
      year: year
    }

    params_for_month_range = {
      month_start: month_start,
      month_end: month_end
    }

    stats_klass.name == 'Stats::ServerSalary' ? params : params.merge(params_for_month_range)
  end

  def date
    @date ||= Date.new(year, month)
  end

  def stats_groups
    self.class::STATS_GROUPS || []
  end

  def sum_columns
    self.class::SUM_COLUMNS || []
  end
end
