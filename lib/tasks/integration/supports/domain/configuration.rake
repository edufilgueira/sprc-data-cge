namespace :integration do
  namespace :supports do
    namespace :domain do
      namespace :configuration do
        task create_or_update: :environment do

          attributes =
          {
            wsdl: 'http://integracao.cge.ce.gov.br/cge-integracao/TabelaExercicioService?wsdl',
            headers_soap_action: '',
            user: 'caiena',
            password: 'ZALbZMyjgv94LBj7CsSq',
            operation: 'consulta_tabela_exercicio',
            response_path: 'consulta_tabela_exercicio_response/tabela_exercicio',
            year: Date.today.year
          }

          # todos os dias as 1:00 a.m
          schedule_attributes = { cron_syntax_frequency: '0 1 * * *' }

          configuration = Integration::Supports::Domain::Configuration.first_or_initialize

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
      # RAILS_ENV=production nohup rake integration:supports:organs:import &
      #

      task import: :environment do
        configuration = Integration::Supports::Domain::Configuration.last
        Integration::Supports::Domain::Importer.call(configuration.id)
      end
    end
  end
end
