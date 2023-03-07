namespace :integration do
  namespace :real_states do
    namespace :configuration do
      task create_or_update: :environment do
        attributes = {
          user: 'caiena',
          password: '-',
          headers_soap_action: '',
          wsdl: 'http://integracao.cge.ce.gov.br/cge-integracao/BensImoveisService?wsdl',
          operation: 'consulta_imoveis',
          response_path: 'consulta_imoveis_response/lista_imoveis/imovel',
          detail_operation: "detalha_imovel",
          detail_response_path: "detalha_imovel_response/imovel"

        }

        configuration = Integration::RealStates::Configuration.first_or_initialize

        # Mensalmente dia 5 às 2:00am
        schedule_attributes = { cron_syntax_frequency: '0 2 5 * *' }

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
    # RAILS_ENV=production nohup rake integration:real_states:import &
    #
    task import: :environment do
      configuration = Integration::RealStates::Configuration.last
      # como não temos mês/ano, temos que rodar apenas uma vez o importer
      Integration::RealStates::Importer.call(configuration.id)
    end
  end
end
