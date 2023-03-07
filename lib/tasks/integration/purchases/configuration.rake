namespace :integration do
  namespace :purchases do
    namespace :configuration do
      task create_or_update: :environment do
        attributes = {
          user: 'caiena',
          password: '-',
          headers_soap_action: '',

          wsdl: 'http://integracao.cge.ce.gov.br/cge-integracao/ComprasService?wsdl',
          operation: 'consulta_compras',
          response_path: 'consulta_compras_response/lista_compras/compras'
        }

        configuration = Integration::Purchases::Configuration.first_or_initialize

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
    # RAILS_ENV=production nohup rake integration:purchases:import &
    #
    task import: :environment do

      configuration = Integration::Purchases::Configuration.last

      old_month_value = configuration.month

      # Devemos dividir em pequenas porções filtradas por período para evitar o readtimeout
      begin_year = 2010
      current_year = Date.current.year
      (begin_year..current_year).to_a.reverse.each do |year|

        last_month = year == current_year ? Date.current.month : 12

        (1..last_month).to_a.reverse.each do |month|

          month_str = "#{month}/#{year}"

          configuration.update_attributes(month: month_str)

          importer = Integration::Purchases::Importer.new(configuration.id)

          logger = importer.logger

          logger.info("[PURCHASES] Importando: #{month_str}")

          importer.call

        end
      end

      configuration.update_attributes(month: old_month_value)
    end
  end
end
