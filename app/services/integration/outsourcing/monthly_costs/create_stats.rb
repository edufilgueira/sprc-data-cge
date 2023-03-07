class Integration::Outsourcing::MonthlyCosts::CreateStats < Integration::BaseCreateStats

  def call
    stats.data = {
      total: sum_for_total(scope_range(year, month)),
      organ: sum_for_organ(scope_range(year, month)),
      category: sum_for_category(scope_range(year, month))
    }

    stats.save
  end

  private

  def stats_klass
    Stats::Outsourcing::MonthlyCost
  end

  def scope_range(year, month)
    Integration::Outsourcing::MonthlyCost
      .where(competencia: "#{month.to_s.rjust(2, '0')}/#{year}")
  end


  def sum_for_total(scope)
    cost = scope.sum(:vlr_custo_total).to_f
    salaries = scope.sum(:remuneracao).to_f
    net_cost = cost - salaries
    {
      total_outsourcing: scope.count,
      total_salaries: salaries,
      total_cost: cost,
      total_net_cost: net_cost
    }
  end

  def sum_for_organ(scope)

    hash_organs = Hash.new
    organs = scope.distinct.pluck(:orgao, :isn_entidade).map do |i|
      {
        orgao: i[0].strip,
        isn_entidade: i[1]
      }
    end


    for organ in organs
      hash_organs[organ[:orgao].to_sym] = total_for_organ(
        scope,
        organ[:isn_entidade],
        organ[:orgao]
      )
    end
    hash_organs
  end

  def sum_for_category(scope)
    hash_categories = Hash.new
    categories = scope.distinct.pluck(:categoria).compact.map do |i|
      { categoria:  i.strip }
    end

    for category in categories
      hash_categories[category[:categoria].to_sym] = total_for_category(
        scope,
        category[:categoria],
        category[:categoria]
      )
    end
    hash_categories
  end

  def total_for_organ(scope, isn, acronym)
    scope = scope.where(isn_entidade: isn)
    {
      count: scope.count,
      total: scope.sum(:vlr_custo_total),
      title: acronym
    }
  end

  def total_for_category(scope, category, acronym)
    scope = scope.where(categoria: category)
    {
      count: scope.count,
      total: scope.sum(:vlr_custo_total),
      title: acronym
    }
  end

end
