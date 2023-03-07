namespace :integration do
  namespace :supports do
    namespace :axis do
      namespace :configuration do
        task create_or_update: :environment do

          attributes =
            {
              wsdl: 'http://integracao.cge.ce.gov.br/cge-integracao/IndicadoresService?wsdl',
              headers_soap_action: '',
              user: 'caiena',
              password: '-',
              operation: 'consulta_eixos',
              response_path: 'consulta_eixos_response/lista_eixos/eixo'
            }

          # todo dia 5 as 2:00a.m
          schedule_attributes = { cron_syntax_frequency: '0 2 5 * *' }

          configuration = Integration::Supports::Axis::Configuration.first_or_initialize

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
      # RAILS_ENV=production nohup rake integration:supports:axis:import &
      #

      task import: :environment do
        axis_configuration = Integration::Supports::Axis::Configuration.last

        Integration::Supports::Axis::Importer.call(axis_configuration.id)
      end
    end
  end
end
