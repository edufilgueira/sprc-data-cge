class Integration::Purchases::CreateStats < Integration::BaseCreateStats

  def call
    stats.data = {
      total: sum_for_scope(active),
      itens: stats_for(:descricao_item),
      fornecedores: stats_for(:nome_fornecedor),
      grupos: stats_for(:nome_grupo),
      resp_compra: stats_for(:nome_resp_compra)
    }

    stats.save
  end

  private

  def stats_klass
    Stats::Purchase
  end

  def active
    Integration::Purchases::Purchase.active_on_month(date)
  end

  def stats_for(key, sum_key=:valor_total_calculated)
    result = {}

    totals = active.group(key).sum(sum_key)
    counts = active.group(key).count

    totals.each do |item, value|
      result[item] = { sum_key => value.to_f, count: counts[item] }
    end

    result
  end

  def sum_for_scope(scope)
    {
      valor_total_calculated: scope.sum(:valor_total_calculated).to_f,
      count: scope.count
    }
  end
end
