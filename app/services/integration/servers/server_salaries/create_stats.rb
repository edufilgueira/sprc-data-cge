class Integration::Servers::ServerSalaries::CreateStats < Integration::BaseCreateStats

  SUM_COLUMNS = [
    :income_total,
    :income_final,
    :income_dailies,
    :discount_total,
    :discount_under_roof,
    :discount_others
  ]

  STATS_GROUPS = [
    :total,
    :functional_status,
    :organ,
    :role
  ]

  SEARCH_INCLUDES = {
    registration: [
      :organ
    ]
  }

  private

  def stats_klass
    Stats::ServerSalary
  end

  def scope
    # O service CreateServerSalaries nem considera as inativas, mas vamos
    # garantir para caso mude a regra.

    Integration::Servers::ServerSalary
      .joins(SEARCH_INCLUDES)
      .where(date: date)
      #with_active_registrations
  end

  def stats_for_functional_status
    result = {}

    Integration::Servers::Registration::functional_statuses.keys.each do |functional_status|
      # Scope usando Registration - Antigo metodo      
      #scope = registrations_with_functional_status(functional_status)

      # Usando o functional_status do server salary
      records = servers_salaries_with_functional_status(functional_status)
      functional_status_str = I18n.t("integration/servers/registration.functional_statuses.#{functional_status}")

      result[functional_status_str] = sum_for_scope(records)
    end

    result
  end

  def stats_for_organ
    stats_for_association(:organ, :sigla, 'integration_servers_registrations.cod_orgao', :codigo_folha_pagamento)
  end

  def stats_for_role
    stats_for_association(:role, :name)
  end

  # def registrations_with_functional_status(functional_status)
  #   functional_status_value = Integration::Servers::Registration::functional_statuses[functional_status]

  #   scope.where('integration_servers_registrations.functional_status': functional_status_value)
  # end

  def servers_salaries_with_functional_status(functional_status)
    functional_status_value = Integration::Servers::Registration::functional_statuses[functional_status]

    scope.where(functional_status: functional_status_value)
  end

  def uniq_from_same_server(scope)
    scope.select('DISTINCT integration_servers_registrations.dsc_cpf')
  end

  # def sum_for_scope(scope)
  #   ids = scope.pluck('DISTINCT integration_servers_server_salaries.id')

  #   result = { income_total: 0,
  #     income_final: 0,
  #     income_dailies: 0,
  #     discount_total: 0,
  #     discount_under_roof: 0,
  #     discount_others: 0,
  #   }

  #   ids.each_slice(300) do |sub_ids|
  #     nscope = Integration::Servers::ServerSalary.where('id IN (?)', sub_ids)

  #     sums = nscope.select(%Q{
  #       sum(income_total) AS income_total,
  #       sum(income_final) AS income_final,
  #       sum(income_dailies) AS income_dailies,
  #       sum(discount_total) AS discount_total,
  #       sum(discount_under_roof) AS discount_under_roof,
  #       sum(discount_others) AS discount_others
  #     })

  #     result[:income_total] += (sums[0].income_total || 0)
  #     result[:income_final] += (sums[0].income_final || 0)
  #     result[:income_dailies] += (sums[0].income_dailies || 0)
  #     result[:discount_total] += (sums[0].discount_total || 0)
  #     result[:discount_under_roof] += (sums[0].discount_under_roof || 0)
  #     result[:discount_others] += (sums[0].discount_others || 0)
  #   end

  #   result.merge({
  #     count: scope.count,
  #     unique_count: uniq_from_same_server(scope).count
  #   })
  # end

  def sum_query_for_scope
    # Montando string do sum Exemplo:
    # sum(income_total) as income_total, sum(income_final) as income_final...
    SUM_COLUMNS.map{ |x| "sum(#{x.to_s}) as #{x.to_s}"}.map(&:to_s).join(', ')
  end

  def sum_for_scope(scope)
    totals = scope.pluck(sum_query_for_scope)[0]
    result = Hash[*SUM_COLUMNS.each_with_index.map{ |x,i| [x, totals[i] || 0] }.flatten]

    result.merge({
      count: scope.count,
      unique_count: uniq_from_same_server(scope).count
    })
  end
end
