class Integration::CityUndertakings::CreateStats < Integration::BaseCreateStats

  def call
    stats.data = {
      total: sum_for_scope(active),
      undertaking: stats_for(:"integration_supports_undertakings.descricao", :undertaking),
      creditor: stats_for(:"integration_supports_creditors.nome", :creditor),
      organ: stats_for(:"integration_supports_organs.sigla", :organ),
      municipio: stats_for(:municipio)
    }

    stats.save
  end

  private

  def stats_klass
    Stats::CityUndertaking
  end

  def active
    Integration::CityUndertakings::CityUndertaking.all
  end

  def stats_for(key, association=nil, sum_key=:valor_executado_total)
    result = {}

    grouped = (association ? active.eager_load(association) : active).group(key)

    totals = grouped.sum(total_sum)
    counts = grouped.count

    totals.each do |item, value|
      result[item] = { sum_key => value.to_f, count: counts[item] }
    end

    result
  end

  def sum_for_scope(scope)
    {
      valor_executado_total: scope.sum(total_sum).to_f,
      count: scope.count
    }
  end

  def total_sum
    (1..8).inject([]) do |array, i|
      array << "COALESCE(valor_executado#{i}, 0)"
      array
    end.join(' + ')
  end
end
