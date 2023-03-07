class Integration::Contracts::Contracts::CreateStats < Integration::Contracts::BaseCreateStats

  STATS_GROUPS = [
    :total,
    :manager,
    :creditor,
    :tipo_objeto,
    :decricao_modalidade
  ]

  private

  def stats_klass
    Stats::Contracts::Contract
  end

  def scope
    Integration::Contracts::Contract.active_on_month(date)
  end

  def stats_for_column(column_name)
    sums = {}

    sum_columns.each do |sum_column|
      # faz a some de cada coluna contabilizada, como por ex:
      #
      # sums[:valor] = scope.group(:razao_social_credor).sum(:valor)
      #
      # => {nil=>0.1e3, "CREDOR 1"=>0.2 e3, "CREDOR 2"=> ...}
      # (Hash em que a chave é cada grupo e o valor a soma de determinada coluna)
      #
      sums[sum_column] = scope.where.not(column_name => nil).group(column_name).sum(sum_column)
      sums[:count] = scope.where.not(column_name => nil).group(column_name).count
    end

    # Precisamos inverter o Hash de algo como { valor: { 'CREDOR'=> 10 } } para
    # algo como { 'CREDOR' => { valor: 10} } pois é esperado um hash em que a
    # chave seja cada séria do gráfico.

    result = reverse_sum_hash(sums)

    # Adiciona a contabilização dos valores não definidos
    result[I18n.t('messages.content.undefined')] = sum_for_scope(scope.where(column_name => nil))

    result
  end
end
