namespace :integration do
  namespace :ppa do
    namespace :source do
      namespace :region do

        # RAILS_ENV=production bundle exec rake integration:ppa:source:region:configuration:create_or_update
        namespace :configuration do
          task create_or_update: :environment do

            attributes =
              {
                wsdl: 'http://integracao.cge.ce.gov.br/cge-integracao/DiretrizesService?wsdl',
                headers_soap_action: '',
                user: 'caiena',
                password: '-',
                operation: 'regioes',
                response_path: 'regioes_response/lista_regioes/regioes'
              }

            # todo dia 1 as 1:00a.m
            schedule_attributes = { cron_syntax_frequency: '0 1 1 * *' }

            configuration = Integration::PPA::Source::Region::Configuration.first_or_initialize

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
        # RAILS_ENV=production nohup bundle exec rake integration:ppa:source:region:import &
        #
        task import: :environment do
          configuration = Integration::PPA::Source::Region::Configuration.last

          Integration::PPA::Source::Region::Importer.call(configuration.id)
        end
      end
    end
  end
end
