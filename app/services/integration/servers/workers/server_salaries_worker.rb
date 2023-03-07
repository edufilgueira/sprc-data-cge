class Integration::Servers::Workers::ServerSalariesWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'servers_import'

  def perform(date, registration_id)
    registration = registration_object(registration_id)


    attributes = {
      server_name: registration.dsc_funcionario,
      role: server_role(registration.dsc_cargo),
      status: status(registration),
      income_total: income_total(date.to_date, registration),
      discount_total: discount_total(date.to_date, registration),
      income_final: income_final,
      discount_under_roof: discount_under_roof(date.to_date, registration),
      discount_others: discount_others(date.to_date, registration),
      income_dailies: income_dailies(date.to_date, registration),
      date: date,
      registration: registration,
      cod_situacao_funcional: registration.cod_situacao_funcional,
      functional_status: registration.functional_status,
      status_situacao_funcional: registration.status_situacao_funcional
    }


    if (attributes[:income_total] != 0 || attributes[:income_final] != 0)
      server_salary = klass.create(attributes)

      if server_salary.errors.present? || !server_salary.persisted?
        raise "Não foi possível salvar: #{server_salary.errors.messages} - #{attributes}"
      end
    end
  end

  private

  def server_role(name)
    return nil unless name.present?
    Integration::Supports::ServerRole.find_or_create_by(name: name)
  end

  def status(registration)
    registration.cod_situacao_funcional.to_i if registration.cod_situacao_funcional.present?
  end

  def income_total(date, registration)
    @income_total = registration.credit_proceeds(date).credit_sum
  end

  def discount_total(date, registration)
    @discount_total = registration.debit_proceeds(date).debit_sum
  end

  def income_final
    @income_total  - @discount_total
  end

  def discount_under_roof(date, registration)
    registration.under_roof_debit_proceeds(date).debit_sum
  end

  def discount_others(date, registration)
    registration.non_under_roof_debit_proceeds(date).debit_sum
  end

  def income_dailies(date, registration)
    month_year = I18n.l(date, format: :month_year)
    Integration::Expenses::Daily.sum_dailies(month_year, registration)
  end

  def registration_object(id)
    registration ||= Integration::Servers::Registration.find(id)
  end

  def klass
    Integration::Servers::ServerSalary
  end

end
