namespace :integration do
  namespace :city_undertakings do
    namespace :configuration do
      task create_or_update: :environment do
        attributes = {
          user: 'caiena',
          password: '-',
          headers_soap_action: '',
          wsdl: 'http://integracao.cge.ce.gov.br/cge-integracao/ContratosConveniosService?wsdl',
          undertaking_operation: "consulta_empreendimentos",
          undertaking_response_path: "consulta_empreendimentos_response/lista_empreendimentos/empreendimento",
          city_undertaking_operation: "consulta_municipios_empreendimentos",
          city_undertaking_response_path: "consulta_municipios_empreendimentos_response/lista_municipios_empreendimentos/municipio_empreendimento",
          city_organ_operation: "consulta_municipios_secretarias",
          city_organ_response_path: "consulta_municipios_secretarias_response/lista_municipios_secretarias/municipio_secretaria"
        }

        configuration = Integration::CityUndertakings::Configuration.first_or_initialize

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
    # RAILS_ENV=production nohup rake integration:city_undertakings:import &
    #
    task import: :environment do
      configuration = Integration::CityUndertakings::Configuration.last
      # como não temos mês/ano, temos que rodar apenas uma vez o importer
      Integration::CityUndertakings::Importer.call(configuration.id)
    end
  end
end
