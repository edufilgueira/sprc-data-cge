class Integration::Expenses::Dailies::CreateStats < Integration::Expenses::BaseCreateStats

  SUM_COLUMNS = [
    :calculated_valor_final
  ]

  STATS_GROUPS = [
    :total,
    :management_unit,
    :creditor
  ]

  private

  def resource_klass
    Integration::Expenses::Daily
  end

  def stats_klass
    Stats::Expenses::Daily
  end
end
