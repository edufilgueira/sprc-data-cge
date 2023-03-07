namespace :integration do
  namespace :supports do
    namespace :creditors do
      namespace :configuration do
        task create_or_update: :environment do

          attributes = {
            wsdl: 'http://integracao.cge.ce.gov.br/cge-integracao/CredorDespesaService?wsdl',
            headers_soap_action: '',
            user: 'caiena',
            password: '-',
            operation: 'consulta_credor',
            response_path: 'consulta_credor_response/credor'
          }

          configuration = Integration::Supports::Creditor::Configuration.first_or_initialize

          # todos os dias as 1:00 a.m
          schedule_attributes = { cron_syntax_frequency: '0 1 * * *' }

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
      # RAILS_ENV=production nohup rake integration:supports:creditors:import &
      #

      task import: :environment do
        creditor_configuration = Integration::Supports::Creditor::Configuration.last

        # Devemos dividir em pequenas porções filtradas por período para evitar o readtimeout
        begin_year = 2010
        current_year = Date.current.year
        (begin_year..current_year).to_a.reverse.each do |year|

          last_month = year == current_year ? Date.current.month : 12

          (1..last_month).to_a.reverse.each do |month|

            date = Date.new(year, month)

            start_date = I18n.l(date.beginning_of_month)
            end_date = I18n.l(date.end_of_month)

            creditor_configuration.update_attributes(started_at: start_date, finished_at: end_date)

            importer = Integration::Supports::Creditor::Importer.new(creditor_configuration.id)

            logger = importer.logger

            logger.info("[CREDITORS] Importando: #{start_date} - #{end_date}")

            importer.call
          end
        end

        creditor_configuration.update_attributes(started_at: '', finished_at: '')
      end
    end
  end
end
