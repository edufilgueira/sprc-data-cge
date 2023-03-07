class Integration::Expenses::CityTransfers::CreateStats < Integration::Expenses::BaseCreateStats

  private

  def resource_klass
    Integration::Expenses::CityTransfer
  end

  def stats_klass
    Stats::Expenses::CityTransfer
  end

  def stats_for_item_despesa
    stats_for_association(:expense_nature_item, :titulo)
  end
end
