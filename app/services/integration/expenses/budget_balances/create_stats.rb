class Integration::Expenses::BudgetBalances::CreateStats < Integration::BaseCreateStats

  SUM_COLUMNS = [
    :calculated_valor_orcamento_inicial,
    :calculated_valor_orcamento_atualizado,
    :calculated_valor_empenhado,
    :calculated_valor_liquidado,
    :calculated_valor_pago
  ]

  STATS_GROUPS = [
    :total,
    :secretary,
    :function,
    :sub_function,
    :government_program,
    :administrative_region
  ]

  INCLUDES = [
    :secretary,
    :organ,
    :function,
    :sub_function,
    :government_program,
    :government_action,
    :administrative_region,
    :expense_nature,
    :qualified_resource_source,
    :finance_group
  ]


  private

  def stats_for_function
    stats_for_association(:function, :titulo)
  end

  def stats_for_secretary
    stats_for_association(:secretary, :title)
  end

  def stats_for_sub_function
    stats_for_association(:sub_function, :title)
  end

  def stats_for_government_program
    stats_for_association(:government_program, :title)
  end

  def stats_for_administrative_region
    stats_for_association(:administrative_region, :title)
  end

  def scope
    resource_klass.from_month_range(year, month_start, month_end).
      includes(INCLUDES).
      references(INCLUDES).
      where('integration_supports_organs.poder = ?', 'EXECUTIVO')
  end

  def resource_klass
    Integration::Expenses::BudgetBalance
  end

  def stats_klass
    Stats::Expenses::BudgetBalance
  end

  # Define se a estatística é anual, como no caso das 'Despesas do poder executivo'
  def stats_yearly?
    true
  end
end
