class Integration::Contracts::ManagementContracts::CreateStats < Integration::Contracts::BaseCreateStats

  STATS_GROUPS = [
    :total,
    :manager,
    :creditor
  ]

  private

  def stats_klass
    Stats::Contracts::ManagementContract
  end

  def scope
    Integration::Contracts::ManagementContract.active_on_month(date)
  end
end
