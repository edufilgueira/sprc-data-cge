namespace :integration do
  namespace :results do
    namespace :configuration do
      task create_or_update: :environment do
        attributes = {
          user: 'caiena',
          password: '-',
          headers_soap_action: '',
          wsdl: 'http://integracao.cge.ce.gov.br/cge-integracao/IndicadoresService?wsdl',
          strategic_indicator_operation: 'consulta_indicadores_estrategicos',
          strategic_indicator_response_path: 'consulta_indicadores_estrategicos_response/lista_indicadores/indicador_estrategico',
          thematic_indicator_operation: 'consulta_indicadores_tematicos',
          thematic_indicator_response_path: 'consulta_indicadores_tematicos_response/lista_indicadores/indicador_tematico'
        }

        configuration = Integration::Results::Configuration.first_or_initialize

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
    # RAILS_ENV=production nohup rake integration:results:import &
    #
    task import: :environment do
      configuration = Integration::Results::Configuration.last
      # como não temos mês/ano, temos que rodar apenas uma vez o importer
      Integration::Results::Importer.call(configuration.id)
    end
  end
end

