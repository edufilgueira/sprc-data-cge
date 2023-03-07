class Integration::Expenses::Neds::CreateStats < Integration::Expenses::BaseCreateStats

  SUM_COLUMNS = [
    :calculated_valor_final,
    :calculated_valor_pago_final
  ]

  STATS_GROUPS = [
    :total,
    :management_unit,
    :razao_social_credor,
    :expense_element
  ]

  private

  def resource_klass
    Integration::Expenses::Ned
  end

  def stats_klass
    Stats::Expenses::Ned
  end

  def stats_for_expense_element
    stats_for_association(:expense_element, :codigo_elemento_despesa)
  end
end
