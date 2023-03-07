class Integration::RealStates::CreateStats < Integration::BaseCreateStats

  def call
    stats.data = {
      total: sum_for_scope(active),
      property_type: stats_for(:"integration_supports_real_states_property_types.title", :property_type),
      occupation_type: stats_for(:"integration_supports_real_states_occupation_types.title", :occupation_type),
      manager: stats_for(:"integration_supports_organs.sigla", :manager),
      municipio: stats_for(:municipio)
    }

    stats.save
  end

  private

  def stats_klass
    Stats::RealState
  end

  def active
    Integration::RealStates::RealState.all
  end

  def stats_for(key, association=nil, sum_key=:area_projecao_construcao)
    result = {}

    grouped = (association ? active.eager_load(association) : active).group(key)

    totals = grouped.sum(sum_key)
    counts = grouped.count

    totals.each do |item, value|
      result[item] = { sum_key => value.to_f, count: counts[item] }
    end

    result
  end

  def sum_for_scope(scope)
    {
      area_projecao_construcao: scope.sum(:area_projecao_construcao).to_f,
      count: scope.count
    }
  end
end
