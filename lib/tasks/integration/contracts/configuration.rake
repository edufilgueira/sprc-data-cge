namespace :integration do
  namespace :contracts do
    namespace :configuration do
      task create_or_update: :environment do

        attributes =
          {
            headers_soap_action: '',
            wsdl: 'http://integracao.cge.ce.gov.br/cge-integracao/ContratosConveniosService?wsdl',
            user: 'caiena',
            password: '-',
            contract_operation: "consulta_contratos_convenios",
            contract_response_path: "consulta_contratos_convenios_response/lista_contratos_convenios/contrato_convenio",
            contract_parameters: "dataAssinaturaInicial=BEGIN_MONTH&dataAssinaturaFinal=END_MONTH",
            additive_operation: "consulta_aditivo",
            additive_response_path: "consulta_aditivo_response/lista_aditivo/aditivo",
            additive_parameters: "dataAditivoInicial=BEGIN_MONTH&dataAditivoFinal=END_MONTH",
            adjustment_operation: "consulta_apostilamento",
            adjustment_response_path: "consulta_apostilamento_response/lista_apostilamento/apostilamento",
            adjustment_parameters: "dataAditivoInicial=BEGIN_MONTH&dataAditivoFinal=END_MONTH",
            financial_operation: "consulta_financeiro",
            financial_response_path: "consulta_financeiro_response/lista_financeiro/financeiro",
            financial_parameters: "dataDocumentoInicial=BEGIN_MONTH&dataDocumentoFinal=END_MONTH",
            infringement_operation: "consulta_inadimplencia",
            infringement_response_path: "consulta_inadimplencia_response/lista_inadimplencia/inadimplencia",
            infringement_parameters: ""
          }

        # todo dia 5 as 2:00a.m
        schedule_attributes = { cron_syntax_frequency: '0 2 5 * *' }


        configuration = Integration::Contracts::Configuration.first_or_initialize

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
    # RAILS_ENV=production nohup rake integration:contracts:daily_update &
    #
    task daily_update: :environment do
      contract_configuration = Integration::Contracts::Configuration.last

      Integration::Contracts::DailyUpdater.delay.call(contract_configuration.id)
    end


    # Rodar em segundo plano
    # RAILS_ENV=production nohup rake integration:contracts:import &
    #
    task import: :environment do

      contract_configuration = Integration::Contracts::Configuration.last

      def contract_configurations_attributes(begin_month, end_month)
        {
          contract_parameters: "dataAssinaturaInicial=BEGIN_MONTH&dataAssinaturaFinal=END_MONTH",
          additive_parameters: "dataAditivoInicial=BEGIN_MONTH&dataAditivoFinal=END_MONTH",
          adjustment_parameters: "dataAditivoInicial=BEGIN_MONTH&dataAditivoFinal=END_MONTH",
          financial_parameters: "dataDocumentoInicial=BEGIN_MONTH&dataDocumentoFinal=END_MONTH",
        }
      end

      # XXX: Não mudamos mais direto nos parâmetros. Usamos o campo específico start_at e end_at
      # Deixando essa linha para garantir que o valor atual está de acordo com o esperado (placeholders)
      contract_configuration.update_attributes(contract_configurations_attributes('BEGIN_MONTH', 'END_MONTH'))

      original_start_at = contract_configuration.start_at
      original_end_at = contract_configuration.end_at

      # Devemos dividir em pequenas porções filtradas por período para evitar o readtimeout
      begin_year = 2007
      current_year = Date.current.year
      (begin_year..current_year).to_a.reverse.each do |year|

        last_month = year == current_year ? Date.current.month : 12

        (1..last_month).to_a.reverse.each do |month|

          date = Date.new(year, month)

          start_date = I18n.l(date.beginning_of_month)
          end_date = I18n.l(date.end_of_month)

          contract_configuration.update_attributes(start_at: start_date, end_at: end_date)

          importer = Integration::Contracts::Importer.new(contract_configuration.id)

          logger = importer.logger

          logger.info("[CONTRACTS] Importando: #{start_date} - #{end_date}")

          importer.call

        end
      end

      contract_configuration.update_attributes(start_at: original_start_at, end_at: original_end_at)
    end

    def create_contracts_stats_or_spreadsheets_for(contract_model_name, key, stats_or_spreadsheets_klass)
      contract_configuration = Integration::Contracts::Configuration.last

      # Cria um importer só pra usar o logger
      importer = Integration::Contracts::Importer.new(contract_configuration.id)

      logger = importer.logger

      contract_name = contract_model_name.to_s.camelize

      begin_year = 2007
      current_year = Date.current.year
      (begin_year..current_year).to_a.reverse.each do |year|

        last_month = year == current_year ? Date.current.month : 12

        (1..last_month).to_a.reverse.each do |month|
          logger.info("[CONTRACTS][#{contract_name.upcase}][#{key}]: #{month}/#{year}")
          stats_or_spreadsheets_klass.call(year, month)
        end
      end
    end

    def create_contracts_stats_for(contract_model_name)
      contract_name = contract_model_name.to_s.camelize
      stats_klass = "::Integration::Contracts::#{contract_name}::CreateStats".constantize
      create_contracts_stats_or_spreadsheets_for(contract_model_name, 'STATS', stats_klass)
    end

    def create_contracts_spreadsheets_for(contract_model_name)
      contract_name = contract_model_name.to_s.camelize
      spreadsheet_klass = "::Integration::Contracts::#{contract_name}::CreateSpreadsheet".constantize
      create_contracts_stats_or_spreadsheets_for(contract_model_name, 'SPREADSHEET', spreadsheet_klass)
    end

    # Rodar em segundo plano
    # RAILS_ENV=production nohup bin/rake integration:contracts:create_stats &
    #
    task create_stats: :environment do
      stats = [
        :convenants,
        :management_contracts,
        :contracts
      ]

      stats.each {|stat| create_contracts_stats_for(stat)}
      stats.each {|stat| create_contracts_spreadsheets_for(stat)}
    end
  end
end
