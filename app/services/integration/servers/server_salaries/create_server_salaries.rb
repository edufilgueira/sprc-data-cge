class Integration::Servers::ServerSalaries::CreateServerSalaries

  attr_reader :date

  def initialize(month_year, configuration = nil)
    @date ||= date_from_month_year(month_year)
    # @cached_server_roles = {}
    @configuration = configuration
  end

  def self.call(month_year, configuration = nil)
    new(month_year).call
  end

  def call
    @logger = Logger.new(log_path)

    create_server_salaries
    while sidekiq_queue_size != 0
      sleep(60)
      log(:info, "Importando ServersSalary. Faltam: #{sidekiq_queue_size}")
    end


    update_organ_server_roles
    sleep(60) #o metodo de cima é muito rapido. Precisa esperar criar jobs na fila
    while sidekiq_queue_size != 0
      sleep(60)
      log(:info, "Importando OrganServerRoles. Faltam: #{sidekiq_queue_size}")
      puts "Importando OrganServerRoles. Faltam: #{sidekiq_queue_size}"
    end

    log(:info, "[SERVERS] ServerSalaries criados para #{month}/#{year}.")
    log(:info, "[SERVERS][STATS] Criando estatística para #{month}/#{year}.")

    create_server_salaries_stats

    log(:info, "[SERVERS][STATS] Criando planilhas para #{month}/#{year}.")

    create_server_salaries_spreadsheet

    log(:info, "[SERVERS] Importação finalizada para #{month}/#{year}.")
  end

  private

  def sidekiq_stats
    @sidekiq_stats = Sidekiq::Stats.new
  end

  def sidekiq_queue_size
    sidekiq_stats.queues['servers_import']
  end

  def create_server_salaries
    Integration::Servers::ServerSalary.where(date: @date).delete_all

    active_registrations.select(:id).joins(:organ).where(integration_supports_organs: {orgao_sfp: true})
    .find_in_batches(batch_size: 1000) do |registration_group|
      registration_group.each do |registration|

        Integration::Servers::Workers::ServerSalariesWorker.perform_async(date, registration.id)
      end
    end
  end

  # def delete_empty_server_salaries
  #   Integration::Servers::ServerSalary.where(income_total: 0, income_final: 0).destroy_all
  # end

  # def delete_inactive_registrations
  #   Integration::Servers::Registration.where(active_functional_status: false).destroy_all
  # end

  # def create_server_salary(date, registration)
  #   server_salary = find_or_initialize_server_salary(date, registration)

  #   if importable?(registration)

  #     server_salary.assign_attributes({
  #       server_name: server_name(registration),
  #       role: role(registration),
  #       status: status(registration),
  #       income_total: income_total(registration),
  #       income_final: income_final(registration),
  #       discount_total: discount_total(registration),
  #       discount_under_roof: discount_under_roof(registration),
  #       discount_others: discount_others(registration),
  #       income_dailies: income_dailies(registration)
  #     })

  #     if (server_salary.income_total > 0 || server_salary.income_final > 0)
  #       server_salary.save
  #     end
  #   end
  # end

  def update_organ_server_roles
    Integration::Supports::OrganServerRole.delete_all
    block = organs.count/6
    
    organs.each_slice(block) do |organ_group|
      Thread.new do

        organ_group.each do |organ|
          role_ids = unique_server_salaries_role_ids_for_organ(organ)
          role_ids.each do |role_id|
            Integration::Supports::OrganServerRole.delay(queue: 'servers_import').create(organ: organ, integration_supports_server_role_id: role_id)
          end
        end
      end
    end
  end


  # Scopes

  def active_registrations
    columns = 'integration_servers_registrations.id, integration_servers_registrations.full_matricula, integration_servers_registrations.cod_orgao, dsc_funcionario, dsc_cargo, cod_situacao_funcional, dsc_cpf'
    Integration::Servers::Registration.active.with_proceeds_from_month(year, month).select(columns).group(columns)
  end



  def organs
    Integration::Supports::Organ.where(orgao_sfp: true).all
  end

  def unique_server_salaries_role_ids_for_organ(organ)
    Integration::Servers::ServerSalary.joins(:registration).where('integration_servers_registrations.cod_orgao': organ.codigo_folha_pagamento).pluck(:integration_supports_server_role_id).uniq
  end

  # Associations

  # def role(registration)
  #   cached_server_role(registration.dsc_cargo)
  # end

  def organ(registration)
    registration.organ
  end



  # def cached_server_role(name)
  #   if @cached_server_roles[name].blank?
  #     @cached_server_roles[name] =
  #       Integration::Supports::ServerRole.find_or_create_by(name: name)
  #   end

  #   @cached_server_roles[name]
  # end

  # Finders

  # def find_or_initialize_server_salary(date, registration)
  #   Integration::Servers::ServerSalary.find_or_initialize_by({
  #     date: date,
  #     registration: registration
  #   })
  # end

  # Calculations

  # def server_name(registration)
  #   registration.dsc_funcionario
  # end

  # def income_total(registration)
  #   registration.credit_proceeds(date).credit_sum
  # end

  # def income_final(registration)
  #   income_total(registration) - discount_total(registration)
  # end

  def discount_under_roof(registration)
    registration.under_roof_debit_proceeds(date).debit_sum
  end

  def discount_others(registration)
    registration.non_under_roof_debit_proceeds(date).debit_sum
  end

  # def discount_total(registration)
  #   registration.debit_proceeds(date).debit_sum
  # end

  # def income_dailies(registration)
  #   month_year = I18n.l(date, format: :month_year)

  #   Integration::Expenses::Daily.sum_dailies(month_year, registration)
  # end

  def create_server_salaries_stats
    #Integration::Servers::ServerSalaries::CreateStats.call(year, month)
    Integration::Servers::Workers::StatsWorker.perform_async(year, month)
    #update_other_services(Integration::Servers::Workers::StatsWorker, 'stats')
  end

  def create_server_salaries_spreadsheet
    Integration::Servers::ServerSalaries::CreateSpreadsheet.call(year, month)

    # Não atualizamos automaticamente as planilhas pois o processo é muito custoso.
    # Caso aparece divergência na planilha de algum mes, deve-se criar manualmente!
    # update_other_services(Integration::Servers::ServerSalaries::CreateSpreadsheet, 'spreadsheets')
  end

  def update_other_services(service, key)
    # além do mês atual, precisamos pedir para recalcular todas as estatística pois
    # pode ter havido alteração na matrícula ocasionando divergência nos números

    all_years = Stats::ServerSalary.distinct.pluck(:year).sort.reverse
    all_months = (1..12).to_a.reverse

    all_years.each do |all_year|
      all_months.each do |all_month|
        next if (all_year == year && all_month == month)

        existing_stat = Stats::ServerSalary.find_by(year: all_year, month: all_month).present?

        if existing_stat
          log(:info, "[SERVERS][#{key.upcase}] Atualizando #{all_month}/#{all_year}.")

          service.perform_async(all_year, all_month)
        end
      end
    end
  end

  # Helpers

  def date_from_month_year(month_year)
    month = (month_year.split('/')[0]).to_i
    year = (month_year.split('/')[1]).to_i
    Date.new(year, month)
  end

  def year
    @date.year
  end

  def month
    @date.month
  end

  def importable?(registration)
    # Só devemos importar matrículas que estejam vinculadas a órgãos com
    # a flag orgao_sfp (true). (sfp = sistema de folha de pagamento).

    registration.orgao_sfp?
  end

  def log_path
    if Rails.env.test?
      Rails.root.to_s + '/log/test_integrations_importer.log'
    else
      Rails.root.to_s + '/log/integrations_importer.log'
    end
  end

  def log(type, message)
    @logger.send(type, message)

    if @configuration.present?
      @configuration.log << "[#{type.upcase}] #{build_message(message)}"
    end
  end
end
