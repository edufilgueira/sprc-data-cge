class Integration::Expenses::ConsortiumTransfers::CreateStats < Integration::Expenses::BaseCreateStats

  private

  def resource_klass
    Integration::Expenses::ConsortiumTransfer
  end

  def stats_klass
    Stats::Expenses::ConsortiumTransfer
  end
end
