class Integration::Constructions::Daes::CreateStats < Integration::BaseCreateStats

  def call
    stats.data = {
      total: stats_for_total,
      descricao: stats_for_descricao,
      municipio: stats_for_municipio,
      secretaria: stats_for_secretaria,
      contratada: stats_for_contratada
    }

    stats.save
  end

  private

  def stats_klass
    Stats::Constructions::Dae
  end

  def stats_for_total
    sum_for_scope(actives)
  end

  def stats_for_descricao
    result = {}

    descriptions.each do |description|
      scope = daes_from_description(description)
      result[description] = sum_for_scope(scope)
    end

    result[I18n.t('messages.content.undefined')] = sum_for_scope(daes_from_description(nil))

    result
  end

  def stats_for_municipio
    result = {}

    cities.each do |city|
      scope = daes_from_city(city)
      result[city] = sum_for_scope(scope)
    end

    result[I18n.t('messages.content.undefined')] = sum_for_scope(daes_from_city(nil))

    result
  end

  def stats_for_secretaria
    result = {}

    organs.each do |organ|
      scope = daes_from_organ(organ)
      result[organ] = sum_for_scope(scope)
    end

    result[I18n.t('messages.content.undefined')] = sum_for_scope(daes_from_organ(nil))

    result
  end

  def stats_for_contratada
    result = {}

    creditors.each do |creditor|
      scope = daes_from_creditor(creditor)
      result[creditor] = sum_for_scope(scope)
    end

    result[I18n.t('messages.content.undefined')] = sum_for_scope(daes_from_creditor(nil))

    result
  end

  def actives
    Integration::Constructions::Dae.active_on_month(date)
  end

  def sum_for_scope(scope)
    {
      valor: scope.sum(:valor).to_f,
      count: scope.count
    }
  end

  def descriptions
    actives.pluck(:descricao).compact.uniq
  end

  def cities
    actives.pluck(:municipio).compact.uniq
  end

  def organs
    actives.pluck(:secretaria).compact.uniq
  end

  def creditors
    actives.pluck(:contratada).compact.uniq
  end

  def daes_from_description(description)
    actives.where(descricao: description)
  end

  def daes_from_city(city)
    actives.where(municipio: city)
  end

  def daes_from_organ(organ)
    actives.where(secretaria: organ)
  end

  def daes_from_creditor(creditor)
    actives.where(contratada: creditor)
  end

end
