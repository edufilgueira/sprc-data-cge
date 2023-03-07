class Integration::Expenses::NonProfitTransfers::CreateStats < Integration::Expenses::BaseCreateStats

  private

  def resource_klass
    Integration::Expenses::NonProfitTransfer
  end

  def stats_klass
    Stats::Expenses::NonProfitTransfer
  end

  def stats_for_item_despesa
    stats_for_association(:expense_nature_item, :titulo)
  end
end
