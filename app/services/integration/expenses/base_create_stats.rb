class Integration::Expenses::BaseCreateStats < Integration::BaseCreateStats

  SUM_COLUMNS = [
    :calculated_valor_final,
    :calculated_valor_pago_final
  ]

  STATS_GROUPS = [
    :total,
    :management_unit,
    :razao_social_credor,
    :item_despesa
  ]

  private

  def scope
    base_scope = resource_klass.from_executivo.ordinarias

    if stats_yearly?
      base_scope.from_year(year)
    else
      base_scope.issued_on_month(date)
    end
  end

  def stats_for_management_unit
    stats_for_association(:management_unit, :codigo)
  end

  def stats_for_creditor
    stats_for_association(:creditor, :title)
  end

  def stats_for_item_despesa
    stats_for_association(:expense_nature_item, :titulo)
  end

  # Define se a estatística é anual, como no caso das 'Despesas do poder executivo'
  def stats_yearly?
    true
  end
end
