namespace :integration do
  namespace :supports do
    namespace :organs do
      namespace :configuration do
        task create_or_update: :environment do

          attributes =
            {
              wsdl: 'http://integracao.cge.ce.gov.br/cge-integracao/OrgaoService?wsdl',
              headers_soap_action: '',
              user: 'caiena',
              password: '-',
              operation: 'consulta_orgaos',
              response_path: 'consulta_orgaos_response/lista_orgao/orgao'
            }

          # todo dia 5 as 2:00a.m
          schedule_attributes = { cron_syntax_frequency: '0 2 5 * *' }

          configuration = Integration::Supports::Organ::Configuration.first_or_initialize

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
      # cd /app/sprc-data/current && RAILS_ENV=production nohup bin/rake integration:supports:organs:import &
      #
      task import: :environment do
        organ_configuration = Integration::Supports::Organ::Configuration.last
        Integration::Supports::Organ::Importer.call(organ_configuration.id)
      end
    end
  end
end
