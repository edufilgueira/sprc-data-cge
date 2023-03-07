#
# Representa 'Despesa com diária'
#
#
class Integration::Expenses::Daily < Integration::Expenses::Npd

  def server_salary
    # Temos que encontrar um registro de salário no mês da emissão da
    # diária.
    if data_emissao.present?
      date = Date.parse(data_emissao).beginning_of_month

      Integration::Servers::ServerSalary.joins(:registration).where('integration_servers_registrations.dsc_cpf = ? AND integration_servers_server_salaries.date = ?', documento_credor, date).first
    end
  end

  # Scope

  ## Class methods

  default_scope do
    where(daily: true)
  end

  def self.from_year(year)
    where(exercicio: year)
  end

  def self.sum_dailies(month_year, registration)
    dailies_for(month_year, registration).sum(:calculated_valor_final)
  end

  def self.from_month_year(month_year)
    issued_on_month(Date.parse(month_year))
  end

  def self.from_cpf_cnpj_credor(cpf_cnpj_credor)
    # joins(nld: :ned).where("cpf_cnpj_credor = ?", cpf_cnpj_credor)
    # XXX tabela NED considera documento sem pontos e traços já a tabela NLD o documento tem pontos e traços
    cpf_cnpj_credor = cpf_cnpj_credor.gsub(/[ \/.-]/, '')

    where("TRANSLATE(documento_credor,' .-/', ' ') = ?", cpf_cnpj_credor)
  end

  #
  # Usado por controllers que possuem o filtro de Credor.
  #
  def self.creditors_name_column
    'integration_supports_creditors.nome'
  end

  def self.dailies_for(month_year, registration)
    cpf_cnpj_credor = registration.dsc_cpf
    codigo_orgao = registration.organ.codigo_orgao

    from_month_year(month_year)
      .from_organ(codigo_orgao)
      .from_cpf_cnpj_credor(cpf_cnpj_credor)
      .ordinarias
  end
end
