class Integration::Constructions::Ders::CreateStats < Integration::BaseCreateStats

  def call
    stats.data = {
      total: stats_for_total,
      servicos: stats_for_servico,
      distrito: stats_for_distrito,
      programa: stats_for_programa,
      construtora: stats_for_construtora
    }

    stats.save
  end

  private

  def stats_klass
    Stats::Constructions::Der
  end

  def stats_for_total
    sum_for_scope(actives)
  end

  def stats_for_servico
    result = {}

    services.each do |services|
      scope = daes_from_services(services)
      result[services] = sum_for_scope(scope)
    end

    result[I18n.t('messages.content.undefined')] = sum_for_scope(daes_from_services(nil))

    result
  end

  def stats_for_distrito
    result = {}

    districts.each do |district|
      scope = daes_from_district(district)
      result[district] = sum_for_scope(scope)
    end

    result[I18n.t('messages.content.undefined')] = sum_for_scope(daes_from_district(nil))

    result
  end

  def stats_for_programa
    result = {}

    programs.each do |program|
      scope = daes_from_program(program)
      result[program] = sum_for_scope(scope)
    end

    result[I18n.t('messages.content.undefined')] = sum_for_scope(daes_from_program(nil))

    result
  end

  def stats_for_construtora
    result = {}

    creditors.each do |creditor|
      scope = daes_from_creditor(creditor)
      result[creditor] = sum_for_scope(scope)
    end

    result[I18n.t('messages.content.undefined')] = sum_for_scope(daes_from_creditor(nil))

    result
  end

  def actives
    Integration::Constructions::Der.active_on_month(date)
  end


  def sum_for_scope(scope)
    {
      valor_aprovado: scope.sum(:valor_aprovado).to_f,
      count: scope.count
    }
  end

  def services
    actives.pluck(:servicos).compact.uniq
  end

  def districts
    actives.pluck(:distrito).compact.uniq
  end

  def programs
    actives.pluck(:programa).compact.uniq
  end

  def creditors
    actives.pluck(:construtora).compact.uniq
  end

  def daes_from_services(services)
    actives.where(servicos: services)
  end

  def daes_from_district(district)
    actives.where(distrito: district)
  end

  def daes_from_program(program)
    actives.where(programa: program)
  end

  def daes_from_creditor(creditor)
    actives.where(construtora: creditor)
  end

end
