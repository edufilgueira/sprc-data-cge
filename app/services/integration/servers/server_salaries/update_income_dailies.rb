class Integration::Servers::ServerSalaries::UpdateIncomeDailies

  attr_reader :logger

  def initialize(month_year_str, dsc_cpf, update_all_stats_param, update_spreadsheet_param)
    @date = month_year_str == 0 ? 0 : Date.parse(month_year_str)
    @update_all_stats_param = update_all_stats_param
    @update_spreadsheet_param = update_spreadsheet_param
    @cpf = dsc_cpf
    @logger = Logger.new(log_path)
  end

  def self.call(month_year_str, dsc_cpf, update_all_stats_param, update_spreadsheet_param)
    new(month_year_str, dsc_cpf, update_all_stats_param, update_spreadsheet_param).call
  end


  def call
    update_income_dailies unless @date == 0

    update_all_stats if @update_all_stats_param

    update_spreadsheet if @update_spreadsheet_param
  end

  private

  def update_income_dailies
    server_salaries.find_each(batch_size: 3000) do |server_salary|
      month_year = @date.to_s
      registration = server_salary.registration
      income_dailies = Integration::Expenses::Daily.sum_dailies(month_year, registration)

      if server_salary.income_dailies != income_dailies
        log(:info, "[SERVERS] Alterando #{server_salary.id} de #{server_salary.income_dailies} para #{income_dailies}")
      end

      server_salary.update_column(:income_dailies, income_dailies)
    end
  end

  def server_salaries
    server_salaries = Integration::Servers::ServerSalary.from_date(@date)

    @cpf.present? ? server_salaries.joins(:registration).where(integration_servers_registrations: { dsc_cpf: @cpf}) : server_salaries
  end

  def update_all_stats
    all_years = Stats::ServerSalary.distinct.pluck(:year).sort.reverse
    all_months = (1..12).to_a.reverse

    all_years.each do |all_year|
      all_months.each do |all_month|
        existing_stat = Stats::ServerSalary.find_by(year: all_year, month: all_month)

        if existing_stat.present?
          log(:info, "[SERVERS] Estatísticas do mês #{all_month}/#{all_month}")

          Integration::Servers::ServerSalaries::CreateStats.call(all_year, all_month)
        end
      end
    end
  end

  def update_spreadsheet
    log(:info, '[SERVERS] Importando planilha')

    Integration::Servers::ServerSalaries::CreateSpreadsheet.call(@date.year, @date.month)
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
  end
end
