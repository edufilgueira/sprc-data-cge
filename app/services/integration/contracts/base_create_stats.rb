class Integration::Contracts::BaseCreateStats < Integration::BaseCreateStats

  SUM_COLUMNS = [
    :valor_contrato,
    :valor_atualizado_concedente
  ]


  private

  def stats_for_manager
    result = {}
    managers.each do |manager|
      scope = resources_for(:manager, manager)
      result[manager.title] = sum_for_scope(scope).merge({title: manager.title})
    end

    result[I18n.t('messages.content.undefined')] = sum_for_scope(resources_for(:manager, nil))

    result
  end

  def stats_for_creditor
    result = stats_for_association(:creditor, :title)

    cpf_cnpj_financiador_for_unknown_creditors.each do |cpf_cnpj_financiador|
      scope = contracts_from_cpf_cnpj_financiador(cpf_cnpj_financiador)

      result[cpf_cnpj_financiador] = sum_for_scope(scope)
    end

    result
  end

  def contracts_from_cpf_cnpj_financiador(cpf_cnpj_financiador)
    scope.where(cpf_cnpj_financiador: cpf_cnpj_financiador)
  end

  def cpf_cnpj_financiador_for_unknown_creditors
    scope.map {|contract| contract.creditor.nil? ? contract.cpf_cnpj_financiador : nil}.uniq.compact
  end

  def managers
    unique_resources(:manager).where(data_termino: nil, codigo_folha_pagamento: nil)
  end
end
