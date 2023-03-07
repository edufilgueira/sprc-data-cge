class Integration::Macroregions::CreateStats < Integration::BaseCreateStats

  def call
    stats.data = {
      total: sum_for_scope(active),
      descricao_regiao: stats_for(:descricao_regiao),
      descricao_poder: stats_for(:descricao_poder),
      ano_exercicio: stats_for(:ano_exercicio)
    }

    stats.save
  end

  private

  def stats_klass
    Stats::MacroregionInvestment
  end

  def active
    Integration::Macroregions::MacroregionInvestiment.active_on_month(date)
  end

  def stats_for(key, sum_key=:valor_lei)
    result = {}

    totals = active.group(key).sum(sum_key)
    counts = active.group(key).count

    totals.each do |item, value|
      result[item] = { sum_key => value.to_f, count: counts[item] }
    end

    result
  end

  def sum_for_scope(scope)
    {
      valor_lei: scope.sum(:valor_lei).to_f,
      count: scope.count
    }
  end
end
