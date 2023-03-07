namespace :integration do
  namespace :ppa do
    namespace :source do
      namespace :guideline do

        # RAILS_ENV=production bundle exec rake integration:ppa:source:guideline:configuration:create_or_update
        namespace :configuration do
          task create_or_update: :environment do

            attributes =
              {
                wsdl: 'http://integracao.cge.ce.gov.br/cge-integracao/DiretrizesService?wsdl',
                headers_soap_action: '',
                user: 'caiena',
                year: '-', # DEVE SER PREENCHIDO!
                password: '-',
                operation: 'listagem_diretrizes',
                response_path: 'listagem_diretrizes_response/lista_diretrizes/diretriz'
              }

            # todo dia 1 as 3:00a.m
            schedule_attributes = { cron_syntax_frequency: '0 3 1 * *' }

            configuration = Integration::PPA::Source::Guideline::Configuration.first_or_initialize

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
        # RAILS_ENV=production nohup bundle exec rake integration:ppa:source:guideline:import &
        #
        task import: :environment do
          configuration = Integration::PPA::Source::Guideline::Configuration.last
          importer_class = Integration::PPA::Source::Guideline::Importer

          importer_class::AVAILABLE_YEARS.each do |year|
            configuration.update! year: year

            importer_class.call configuration.reload.id
          end
        end
      end
    end
  end
end
