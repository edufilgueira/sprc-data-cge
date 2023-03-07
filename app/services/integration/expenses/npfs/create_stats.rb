class Integration::Expenses::Npfs::CreateStats < Integration::Expenses::BaseCreateStats

  SUM_COLUMNS = [
    :valor
  ]

  STATS_GROUPS = [
    :total,
    :management_unit,
    :creditor
  ]

  private

  def stats_klass
    Stats::Expenses::Npf
  end

  def scope
    Integration::Expenses::Npf.issued_on_month(date)
  end

  def stats_for_creditor
    stats_for_association(:creditor, :title)
  end
end
