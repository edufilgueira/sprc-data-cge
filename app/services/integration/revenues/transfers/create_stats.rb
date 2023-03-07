class Integration::Revenues::Transfers::CreateStats < Integration::Revenues::Accounts::CreateStats

  STATS_GROUPS = [
    :total,
    :secretary,
    :transfer
  ]

  private

  def stats_klass
    Stats::Revenues::Transfer
  end

  def scope
    revenues.joins(:organ, { accounts: :revenue_nature }).where(%q{
      integration_supports_revenue_natures.transfer_voluntary = ? OR
      integration_supports_revenue_natures.transfer_required = ?
    }, true, true)
  end

  def stats_for_total
    accounts = scope

    {
      valor_previsto_inicial: valor_previsto_inicial(accounts),
      valor_previsto_atualizado: valor_previsto_atualizado(accounts),
      valor_arrecadado: valor_arrecadado(accounts),
      count: revenues_count_from_scope(accounts)
    }
  end

  def stats_for_transfer
    result = {}

    [:required, :voluntary].each do |transfer_type|

      title = Integration::Supports::RevenueNature.human_attribute_name("transfer_#{transfer_type}")
      accounts = accounts_from_transfer_type(transfer_type)

      result[title] = stats_for_accounts(accounts)
    end

    result
  end

  def accounts_from_transfer_type(transfer_type)
    scope.where("integration_supports_revenue_natures.transfer_#{transfer_type} = ?", true)
  end
end
