namespace :integration do
  namespace :ppa do
    namespace :source do
      namespace :axis_theme do

        #
        # RAILS_ENV=production bundle exec rake integration:ppa:source:axis_theme:configuration:create_or_update
        #
        namespace :configuration do
          desc 'Cria ou atualiza a configuração para importação em PPA::Source::AxisTheme::Configuration'
          task create_or_update: :environment do

            attributes =
              {
                wsdl: 'http://integracao.cge.ce.gov.br/cge-integracao/DiretrizesService?wsdl',
                headers_soap_action: '',
                user: 'caiena',
                password: '-',
                operation: 'eixos_temas',
                response_path: 'eixos_temas_response/lista_eixos_temas/eixos_temas'
              }

            # todo dia 1 as 2:00a.m
            schedule_attributes = { cron_syntax_frequency: '0 2 1 * *' }

            configuration = Integration::PPA::Source::AxisTheme::Configuration.first_or_initialize

            # Não altera configurações já existentes.
            if configuration.new_record?
              configuration.assign_attributes(attributes)

              configuration.build_schedule
              configuration.schedule.assign_attributes(schedule_attributes)

              configuration.save!
            end
          end
        end

        #
        # Rodar em segundo plano
        # RAILS_ENV=production nohup bundle exec rake integration:ppa:source:axis_theme:import &
        #
        desc 'Inicia uma importação usando Integration::PPA::Source::AxisTheme::Importer'
        task import: :environment do
          configuration = Integration::PPA::Source::AxisTheme::Configuration.last

          Integration::PPA::Source::AxisTheme::Importer.call(configuration.id)
        end
      end
    end
  end
end
