class Integration::Revenues::Accounts::CreateStats < Integration::BaseCreateStats

  # Regras documentadas:
  #
  # natureza_conta = 'DÉBITO    ' e codigo = '9' faça (valor_debito - valor_credito)
  # natureza_conta = 'DÉBITO    ' e codigo = '8' faça (valor_debito - valor_credito)
  # natureza_conta = 'DÉBITO    ' e codigo = '1' faça (valor_debito - valor_credito)

  # natureza_conta = 'CRÉDITO   ' e codigo = '9' faça (valor_credito - valor_debito)
  # natureza_conta = 'CRÉDITO   ' e codigo = '8' faça (valor_credito - valor_debito)
  # natureza_conta = 'CRÉDITO   ' e codigo = '1' faça (valor_credito - valor_debito)
  #
  # 5211 – Previsão de Receita
  # 52121 – Previsão de Receita Adicional
  # 52129 – Anulação de Previsão de Receita
  # 6212 – Receita Corrente
  # 6213 – Deduções da Receita
  #
  # Valor Previsto = 5211
  # Valor Atualizado = (5211 + 52121) – 52129
  # Valor Arrecadado = 6212 - 6213
  #
  #
  # Integration::Revenues::Revenue possui relação com órgão/secretaria, além
  # de possuir os códigos.
  #
  # A soma deve ser feita no model Integration::Revenues::Account, que possui
  # a classificação da natureza da receita.
  #

  ACCOUNTS = {
    previsto_inicial: ['5.2.1.1.1'],

    previsto_inicial_anulado: [
      '5.2.1.1.2.01.01',
      '5.2.1.2.1.03.01'
    ], # * 5.2.1.2.1.03.01 talvez n seja aqui

    previsto_adicional: [
      '5.2.1.2.1.01',
      '5.2.1.2.1.02'
    ],

    previsto_anulado: [
      '5.2.1.1.2.02',
      '5.2.1.1.2.99',
      '5.2.1.2.1.03.02',
      '5.2.1.2.1.04',
      '5.2.1.2.1.99',
      '5.2.1.2.9'
    ],

    receita_corrente: ['6.2.1.2'],

    deducoes_receita: [
      '6.2.1.3.1.01',
      '6.2.1.3.1.02',
      '6.2.1.3.2',
      '6.2.1.3.9.01'
    ]
  }

  STATS_GROUPS = [
    :total,
    :secretary,
    :consolidado,
    :categoria_economica,
    :origem,
    :subfonte
  ]

  private

  def year_for_revenue_nature
    if year <= 2018
      2018
    else
      year
    end
  end

  def stats_klass
    Stats::Revenues::Account
  end

  def scope
    revenues.joins(:organ, { accounts: :revenue_nature })
      .where(integration_supports_revenue_natures: {year: year})
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

  def stats_for_secretary
    result = {}

    secretaries_with_accounts.each do |secretary|
      secretary_accounts = accounts_from_secretary(secretary)

      result[secretary.title] = stats_for_accounts(secretary_accounts)
    end

    result
  end

  def stats_for_consolidado
    stats_for_revenue_nature(:consolidado)
  end

  def stats_for_categoria_economica
    stats_for_revenue_nature(:categoria_economica)
  end

  def stats_for_origem
    stats_for_revenue_nature(:origem)
  end

  def stats_for_subfonte
    stats_for_revenue_nature(:subfonte)
  end

  def stats_for_revenue_nature(revenue_nature_type)
    result = {}

    revenue_natures_with_accounts(revenue_nature_type).each do |revenue_nature|
      revenue_nature_accounts = accounts_from_revenue_nature(revenue_nature_type, revenue_nature)

      result[revenue_nature.title] = stats_for_accounts(revenue_nature_accounts)
    end

    result
  end

  def stats_for_accounts(accounts)
    {
      valor_previsto_inicial: valor_previsto_inicial(accounts),
      valor_previsto_atualizado: valor_previsto_atualizado(accounts),
      valor_arrecadado: valor_arrecadado(accounts),
      count: revenues_count_from_scope(accounts)
    }
  end

  def valor_previsto_inicial(accounts)
    total_for_account_type(accounts, :previsto_inicial) -
    total_for_account_type(accounts, :previsto_inicial_anulado)
  end

  def valor_previsto_atualizado(accounts)
    valor_previsto_inicial(accounts) +
    valor_previsto_adicional(accounts) -
    valor_previsto_anulado(accounts)
  end

  def valor_arrecadado(accounts)
    valor_receita_corrente(accounts) - valor_deducoes_receita(accounts)
  end

  def valor_previsto_adicional(accounts)
    total_for_account_type(accounts, :previsto_adicional)
  end

  def valor_previsto_anulado(accounts)
    total_for_account_type(accounts, :previsto_anulado)
  end

  def valor_receita_corrente(accounts)
    total_for_account_type(accounts, :receita_corrente)
  end

  def valor_deducoes_receita(accounts)
    total_for_account_type(accounts, :deducoes_receita)
  end

  def total_for_account_type(accounts, account_type)
    total_debito = accounts_sum(accounts, ACCOUNTS[account_type], 'DÉBITO')
    total_credito = accounts_sum(accounts, ACCOUNTS[account_type], 'CRÉDITO')

    total =  total_debito + total_credito
  end

  def accounts_sum(accounts, account_number, account_type)
    filtered_accounts = accounts.
      where(natureza_da_conta: account_type).
      where(conta_contabil: account_number)

    # Somamos das contas e não das 'revenues'
    total_valor_inicial = filtered_accounts.sum('integration_revenues_accounts.valor_inicial')
    total_valor_debito = filtered_accounts.sum('integration_revenues_accounts.valor_debito')
    total_valor_credito = filtered_accounts.sum('integration_revenues_accounts.valor_credito')

    total_movimentado = account_type == 'CRÉDITO' ?
      (total_valor_credito - total_valor_debito) :
      (total_valor_debito - total_valor_credito)

    (total_valor_inicial + total_movimentado)
  end

  def revenues

    # estatística de período mensal
    return Integration::Revenues::Revenue.from_month_range(month_start, month_end, year) if month_end.present?

    # estatística anual tem mes = 0
    return Integration::Revenues::Revenue.from_year(year) if month == 0

    Integration::Revenues::Revenue.from_month_and_year(date)
  end

  def revenues_count_from_scope(scope)
    scope.select('DISTINCT integration_revenues_revenues.id').count
  end

  # Secretary

  def secretaries_with_accounts
    organ_ids = scope.
      pluck('DISTINCT integration_revenues_revenues.integration_supports_secretary_id').uniq.compact

    Integration::Supports::Organ.where('id IN (?)', organ_ids)
  end

  def accounts_from_secretary(secretary)
    scope.where('integration_revenues_revenues.integration_supports_secretary_id = ?', secretary.id)
  end

  # RevenueNature (:consolidado, categoria_economica, ...)

  def revenue_natures_with_accounts(revenue_nature_type)
    column_name = revenue_nature_unique_id_column_name(revenue_nature_type)

    unique_ids_select = "DISTINCT integration_supports_revenue_natures.#{column_name}"
    unique_ids = scope.pluck(unique_ids_select).compact

    Integration::Supports::RevenueNature.where('unique_id IN (?)', unique_ids)
  end

  def accounts_from_revenue_nature(revenue_nature_type, revenue_nature)
    column_name = revenue_nature_unique_id_column_name(revenue_nature_type)

    scope.where("integration_supports_revenue_natures.#{column_name} = ?", revenue_nature.unique_id)
  end

  def revenue_nature_unique_id_column_name(revenue_nature_type)
    "unique_id_#{revenue_nature_type}"
  end
end
