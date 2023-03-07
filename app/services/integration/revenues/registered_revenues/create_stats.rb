class Integration::Revenues::RegisteredRevenues::CreateStats < Integration::Revenues::Accounts::CreateStats

  ACCOUNTS = {
    ipva: ['4.1.1.2.1.03.01', '4.1.1.2.1.06'],
    restituicoes_ipva: ['4.1.1.2.1.97.01'],
    deducoes_ipva: ['4.1.1.2.1.97.11']
  }

  STATS_GROUPS = [
    :total,
    :month,
    :revenue
  ]

  private

  def stats_klass
    Stats::Revenues::RegisteredRevenue
  end

  def scope
    revenues
  end

  def stats_for_total
    {
      valor_lancado: valor_lancado(scope),
      count: revenues.count
    }
  end

  def stats_for_month
    result = {}

    months_with_revenues.each do |month|
      month_revenues = revenues_from_month(month)

      result[month] = {
        valor_lancado: valor_lancado(month_revenues),
        count: month_revenues.count
      }
    end

    result
  end

  def months_with_revenues
    scope.pluck('DISTINCT integration_revenues_revenues.month')
  end

  def revenues_from_month(month)
    scope.where('integration_revenues_revenues.month = ?', month)
  end

  def stats_for_revenue
    result = {}

    conta_contabils_with_revenues.each do |conta_contabil_info|

      conta_contabil = conta_contabil_info[0]
      conta_contabil_title = conta_contabil_info[1]

      conta_contabil_revenues = revenues_from_conta_contabil(conta_contabil)

      result[conta_contabil_title] = {
        valor_lancado: valor_lancado(conta_contabil_revenues),
        count: conta_contabil_revenues.count
      }
    end

    result
  end

  def conta_contabils_with_revenues
    scope.where('integration_revenues_revenues.conta_contabil IN (?)', ACCOUNTS.values.flatten).pluck('DISTINCT integration_revenues_revenues.conta_contabil, integration_revenues_revenues.titulo')
  end

  def revenues_from_conta_contabil(conta_contabil)
    scope.where('integration_revenues_revenues.conta_contabil = ?', conta_contabil)
  end

  def valor_lancado(revenues)
    sum = revenues_sum(revenues)

    (sum[:ipva] - sum[:restituicoes_ipva] - sum[:deducoes_ipva])
  end

  def revenues_sum(revenues)
    rows = revenues.group(:natureza_da_conta, :conta_contabil).select(revenues_sum_expression)
    result = {
      ipva: 0,
      restituicoes_ipva: 0,
      deducoes_ipva: 0
    }

    rows.each do |row|
      result[:ipva] += row.total_ipva
      result[:restituicoes_ipva] += row.total_restituicoes_ipva
      result[:deducoes_ipva] += row.total_deducoes_ipva
    end

    result
  end

  def revenues_sum_expression

    return @revenues_sum_expression if @revenues_sum_expression.present?

    base_expresion = %Q{
            ( CASE
          WHEN integration_revenues_revenues.natureza_da_conta = 'DÉBITO' AND (integration_revenues_revenues.conta_contabil in %{account_number} ) THEN
            sum(integration_revenues_revenues.valor_inicial) + (sum(integration_revenues_revenues.valor_debito) - sum(integration_revenues_revenues.valor_credito))

          WHEN integration_revenues_revenues.natureza_da_conta = 'CRÉDITO' AND (integration_revenues_revenues.conta_contabil in %{account_number} )  THEN
            sum(integration_revenues_revenues.valor_inicial) + (sum(integration_revenues_revenues.valor_credito) - sum(integration_revenues_revenues.valor_debito))

          ELSE
            0
        END
      ) AS total_%{account_type}
    }

    result = []

    ACCOUNTS.each do |account_type, account_number|

      result << base_expresion % { account_type: account_type, account_number: account_number.to_s.gsub('[', '(').gsub(']', ')').gsub('"',"'") }

    end

    @revenues_sum_expression = result.join(', ')
  end
end
