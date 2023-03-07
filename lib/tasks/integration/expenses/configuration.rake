namespace :integration do
  namespace :expenses do
    namespace :configuration do
      task create_or_update: :environment do
        attributes =
          {
            npf_wsdl: 'http://integracao.cge.ce.gov.br/cge-integracao/NotaProgramacaoFinanceiraService?wsdl',
            npf_headers_soap_action: '',
            npf_user: 'caiena',
            npf_password: '-',
            npf_operation: 'consulta_nota_programacao_financeira',
            npf_response_path: 'consulta_nota_programacao_financeira_response/nota_programacao_financeira',

            ned_wsdl: 'http://integracao.cge.ce.gov.br/cge-integracao/NotaEmpenhoDespesaService?wsdl',
            ned_headers_soap_action: '',
            ned_user: 'caiena',
            ned_password: '-',
            ned_operation: 'consulta_nota_empenho_despesa',
            ned_response_path: 'consulta_nota_empenho_despesa_response/nota_empenho_despesa',

            nld_wsdl: 'http://integracao.cge.ce.gov.br/cge-integracao/NotaLiquidacaoDespesaService?wsdl',
            nld_headers_soap_action: '',
            nld_user: 'caiena',
            nld_password: '-',
            nld_operation: 'consulta_nota_liquidacao_despesa',
            nld_response_path: 'consulta_nota_liquidacao_despesa_response/nota_liquidacao_despesa',

            npd_wsdl: 'http://integracao.cge.ce.gov.br/cge-integracao/NotaPagamentoDespesaService?wsdl',
            npd_headers_soap_action: '',
            npd_user: 'caiena',
            npd_password: '-',
            npd_operation: 'consulta_nota_pagamento_despesa',
            npd_response_path: 'consulta_nota_pagamento_despesa_response/nota_pagamento_despesa',

            budget_account_wsdl: 'http://integracao.cge.ce.gov.br/cge-integracao/SaldoOrcamentarioService?wsdl',
            budget_account_headers_soap_action: '',
            budget_account_user: 'caiena',
            budget_account_password: '-',
            budget_account_operation: 'consulta_saldo_orcamentario',
            budget_account_response_path: 'consulta_saldo_orcamentario_response/saldo_orcamentario'
          }

        configuration = Integration::Expenses::Configuration.first_or_initialize

        # todos os dias as 2:00 a.m
        schedule_attributes = { cron_syntax_frequency: '0 2 * * *' }

        # Não altera configurações já existentes.
        if configuration.new_record?
          configuration.assign_attributes(attributes)

          configuration.build_schedule
          configuration.schedule.assign_attributes(schedule_attributes)

          configuration.save!
        end
      end
    end

    # Rodar em segundo plano
    # RAILS_ENV=production BYPASS_STATS=1 BYPASS_SPREADSHEETS=1 nohup bin/rake integration:expenses:import &
    #
    task import: :environment do
      expense_configuration = Integration::Expenses::Configuration.last

      old_started_at = expense_configuration.started_at
      old_finished_at = expense_configuration.finished_at

      # Devemos tomar cuidado ao definir o período de importação de despesas,
      # Hoje a importação é diária pela quantidade de dados vinda do web service.
      # Desta forma, cada importação gera um processo no servidor
      current_date = Date.parse('01/01/2013')
      end_date = Date.today

      while(current_date <= end_date)

        week_start = current_date
        week_end = week_start + 3.days

        expense_configuration.update_attributes(started_at: week_start, finished_at: week_end)

        importer = Integration::Expenses::Importer.new(expense_configuration.id)

        logger = importer.logger

        logger.info("[EXPENSES] Importando: #{week_start} - #{week_end}")

        importer.call

        current_date = week_end + 1.day
      end

      expense_configuration.update_attributes(started_at: old_started_at, finished_at: old_finished_at)
    end

    # Rodar em segundo plano
    # RAILS_ENV=production BYPASS_STATS=1 BYPASS_SPREADSHEETS=1 nohup bin/rake integration:expenses:daily_update &
    #
    task daily_update: :environment do
      expense_configuration = Integration::Expenses::Configuration.last

      old_started_at = expense_configuration.started_at
      old_finished_at = expense_configuration.finished_at

      # Devemos tomar cuidado ao definir o período de importação de despesas,
      # Hoje a importação é diária pela quantidade de dados vinda do web service.
      # Desta forma, cada importação gera um processo no servidor
      current_date = Integration::Expenses::Ned.order(:date_of_issue).last.date_of_issue
      end_date = Date.today

      while(current_date <= end_date)
        week_start = current_date
        week_end = week_start

        expense_configuration.update_attributes(started_at: week_start, finished_at: week_end)

        importer = Integration::Expenses::Importer.new(expense_configuration.id)

        logger = importer.logger

        logger.info("[EXPENSES] Importando: #{week_start} - #{week_end}")

        importer.call

        current_date = week_end + 1.day
      end

      expense_configuration.update_attributes(started_at: old_started_at, finished_at: old_finished_at)
    end

    def create_stats_for(expense_model_name, years)
      expense_configuration = Integration::Expenses::Configuration.last

      # Cria um importer só pra usar o logger
      importer = Integration::Expenses::Importer.new(expense_configuration.id)

      logger = importer.logger

      expense_name = expense_model_name.to_s.camelize

      stats_klass = "::Integration::Expenses::#{expense_name}::CreateStats".constantize
      spreadsheet_klass = "::Integration::Expenses::#{expense_name}::CreateSpreadsheet".constantize

      years.each do |year|
        logger.info("[EXPENSES][#{expense_name.upcase}][STATS]: #{year}")
        stats_klass.delay.call(year, 0)

        logger.info("[EXPENSES][#{expense_name.upcase}][SPREADSHEET]: #{year}")
        spreadsheet_klass.delay.call(year, 0)
      end
    end

    def create_stats_month_range_for(expense_model_name, years)
      expense_configuration = Integration::Expenses::Configuration.last

      # Cria um importer só pra usar o logger
      importer = Integration::Expenses::Importer.new(expense_configuration.id)

      logger = importer.logger

      expense_name = expense_model_name.to_s.camelize

      stats_klass = "::Integration::Expenses::#{expense_name}::CreateStats".constantize
      spreadsheet_klass = "::Integration::Expenses::#{expense_name}::CreateSpreadsheet".constantize

      current_year = Date.current.year
      current_month = Date.current.month

      years.each do |year|
        month = year == current_year ? current_month : 12

        (1..month).each do |month_start|
          (month_start..month).each do |month_end|
            month_range = { month_start: month_start, month_end: month_end }

            logger.info("[EXPENSES][#{expense_name.upcase}][STATS]: #{year}/#{month_start}-#{month_end}")
            stats_klass.delay.call(year, 0, month_range)

            logger.info("[EXPENSES][#{expense_name.upcase}][SPREADSHEET]: #{year}/#{month_start}-#{month_end}")
            spreadsheet_klass.delay.call(year, 0, month_range)
          end
        end
      end
    end

    def expenses_default_years
      first_year = Integration::Expenses::Ned.order(:date_of_issue).first.date_of_issue.year
      last_year = Integration::Expenses::Ned.order(:date_of_issue).last.date_of_issue.year

      (first_year..last_year).to_a.reverse
    end

    def expenses_stats
      [
        :dailies,
        :neds,
        :budget_balances,
        :city_transfers,
        :non_profit_transfers,
        :profit_transfers,
        :multi_gov_transfers,
        :consortium_transfers,
        :fund_supplies
      ]
    end

    # Rodar em segundo plano
    # RAILS_ENV=production nohup bin/rake integration:expenses:create_stats &
    #
    task create_stats: :environment do
      if stat == :budget_balances
        create_stats_month_range_for.each {|stat| create_stats_for(stat, expenses_default_years)}
      else
        expenses_stats.each {|stat| create_stats_for(stat, expenses_default_years)}
      end
    end

    # Rodar em segundo plano
    # RAILS_ENV=production nohup bin/rake integration:expenses:create_stats_for_current_year &
    #
    task :create_stats_for_current_year, [:year] => :environment do |t, args|

      current_year = args[:year].try(:to_i) || Date.today.year
      expenses_stats.each do |stat|
        if stat == :budget_balances
          create_stats_month_range_for(stat, [current_year])
        else
          create_stats_for(stat, [current_year])
        end
      end
    end

    namespace :neds do
      # Rodar em segundo plano
      # RAILS_ENV=production nohup bin/rake integration:expenses:neds:create_stats &
      #
      task create_stats: :environment do
        create_stats_for(:neds, expenses_default_years)
      end
    end

    namespace :budget_balances do
      # Rodar em segundo plano
      # RAILS_ENV=production nohup bin/rake integration:expenses:budget_balances:create_stats &
      #
      task create_stats: :environment do
        create_stats_month_range_for(:budget_balances, expenses_default_years)
      end
    end

    namespace :city_transfers do
      # Rodar em segundo plano
      # RAILS_ENV=production nohup bin/rake integration:expenses:city_transfers:create_stats &
      #
      task create_stats: :environment do
        create_stats_for(:city_transfers, expenses_default_years)
      end
    end

    namespace :non_profit_transfers do
      # Rodar em segundo plano
      # RAILS_ENV=production nohup bin/rake integration:expenses:non_profit_transfers:create_stats &
      #
      task create_stats: :environment do
        create_stats_for(:non_profit_transfers, expenses_default_years)
      end
    end

    namespace :profit_transfers do
      # Rodar em segundo plano
      # RAILS_ENV=production nohup bin/rake integration:expenses:profit_transfers:create_stats &
      #
      task create_stats: :environment do
        create_stats_for(:profit_transfers, expenses_default_years)
      end
    end

    namespace :multi_gov_transfers do
      # Rodar em segundo plano
      # RAILS_ENV=production nohup bin/rake integration:expenses:multi_gov_transfers:create_stats &
      #
      task create_stats: :environment do
        create_stats_for(:multi_gov_transfers, expenses_default_years)
      end
    end

    namespace :consortium_transfers do
      # Rodar em segundo plano
      # RAILS_ENV=production nohup bin/rake integration:expenses:consortium_transfers:create_stats &
      #
      task create_stats: :environment do
        create_stats_for(:consortium_transfers, expenses_default_years)
      end
    end

    namespace :fund_supplies do
      # Rodar em segundo plano
      # RAILS_ENV=production nohup bin/rake integration:expenses:fund_supplies:create_stats &
      #
      task create_stats: :environment do
        create_stats_for(:fund_supplies, expenses_default_years)
      end
    end

    namespace :dailies do
      # Rodar em segundo plano
      # RAILS_ENV=production nohup bin/rake integration:expenses:dailies:create_stats &
      #
      task create_stats: :environment do
        create_stats_for(:dailies, expenses_default_years)
      end
    end
  end
end
