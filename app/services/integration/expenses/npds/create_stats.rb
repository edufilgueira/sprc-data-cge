class Integration::Expenses::Npds::CreateStats <  Integration::Expenses::BaseCreateStats

  SUM_COLUMNS = [
    :valor
  ]

  STATS_GROUPS = [
    :total,
    :management_unit,
    :creditor
  ]

  private

  def resource_klass
    Integration::Expenses::Npd
  end

  def stats_klass
    Stats::Expenses::Npd
  end

  # Define se a estatística é anual, como no caso das 'Despesas do poder executivo'
  def stats_yearly?
    false
  end
end
