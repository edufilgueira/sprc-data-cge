namespace :integration do
  namespace :revenues do
    namespace :configuration do
      task create_or_update: :environment do

        attributes = {
          wsdl: 'http://integracao.cge.ce.gov.br/cge-integracao/SaldoContaReceitaService?wsdl',
          headers_soap_action: '',
          user: 'caiena',
          password: '-',
          operation: 'consulta_saldo_contas_contabeis',
          response_path: 'consulta_saldo_contas_contabeis_response/conta'
        }

        accounts = [
          {
            title: 'PREVISÃO DE RECEITA',
            account_number: '5.2.1.1'
          },
          {
            title: 'PREVISÃO DE RECEITA',
            account_number: '5.2.1.1.1'
          },
          {
            title: 'PREVISÃO ADICIONAL DE RECEITA',
            account_number: '5.2.1.2.1'
          },
          {
            title: 'PREVISÃO ADICIONAL DE RECEITA',
            account_number: '5.2.1.2.1.0.1'
          },
          {
            title: 'PREVISÃO ADICIONAL DE RECEITA',
            account_number: '5.2.1.2.1.0.2'
          },
          {
            title: 'ANULAÇAO DE PREVISÃO DE RECEITA',
            account_number: '5.2.1.2.9'
          },
          {
            title: 'RECEITA REALIZADA',
            account_number: '6.2.1.2'
          },
          {
            title: 'DEDUÇÕES DA RECEITA REALIZADA',
            account_number: '6.2.1.3'
          },
          {
            title: 'IPVA',
            account_number: '4.1.1.2.1.03.01'
          },
          {
            title: '(-) Restituições da Receita com IPVA',
            account_number: '4.1.1.2.1.97.01'
          },
          {
            title: '(-) Deduções do IPVA para o FUNDEB',
            account_number: '4.1.1.2.1.97.11'
          }
        ]

        configuration = Integration::Revenues::Configuration.first_or_initialize

        # todo dia 5 as 2:00a.m
        schedule_attributes = { cron_syntax_frequency: '0 2 5 * *' }

        # Não altera configurações já existentes.
        if configuration.new_record?
          configuration.assign_attributes(attributes)

          configuration.build_schedule
          configuration.schedule.assign_attributes(schedule_attributes)

          configuration.save!
        end

        accounts.each do |account|
          Integration::Revenues::AccountConfiguration.find_or_create_by({
            configuration: configuration,
            title: account[:title],
            account_number: account[:account_number]
          })
        end
      end
    end

    # Rodar em segundo plano
    # cd /app/sprc-data/current && RAILS_ENV=production nohup bundle exec rake integration:revenues:import &
    #
    task import: :environment do
      revenue_configuration = Integration::Revenues::Configuration.last

      # Devemos dividir em pequenas porções filtradas por período para evitar o readtimeout
      current_year = Date.current.year
      (2013..current_year).to_a.each do |year|
        last_month = year == current_year ? Date.current.month : 12

        ('01'..last_month.to_s).each do |month|
          month = "#{month}/#{year}"

          revenue_configuration.update_attributes(month: month)

          importer = Integration::Revenues::Importer.new(revenue_configuration.id)

          logger = importer.logger

          logger.info("[REVENUES] Importando: #{month}")

          importer.call
        end
      end

      revenue_configuration.update_attributes(month: '')
    end
  end
end
