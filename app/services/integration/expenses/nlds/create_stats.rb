class Integration::Expenses::Nlds::CreateStats <  Integration::Expenses::BaseCreateStats

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
    Integration::Expenses::Nld
  end

  def stats_klass
    Stats::Expenses::Nld
  end

  # Define se a estatística é anual

  def stats_yearly?
    false
  end
end
