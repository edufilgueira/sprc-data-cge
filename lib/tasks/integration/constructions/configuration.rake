namespace :integration do
  namespace :constructions do
    namespace :configuration do
      task create_or_update: :environment do

        attributes =
          {
            user: 'caiena',
            password: '-',
            headers_soap_action: '',

            der_wsdl: 'http://integracao.cge.ce.gov.br/cge-integracao/ObrasDerService?wsdl',
            dae_wsdl: 'http://integracao.cge.ce.gov.br/cge-integracao/ObrasDaeService?wsdl',

            der_operation: 'consulta_obras',
            der_response_path: 'consulta_obras_response/lista_obras/obra',

            der_contract_operation: "consulta_contratos_obras",
            der_contract_response_path: "consulta_contratos_obras_response/lista_contratos_obras/contrato_obra",

            der_measurement_operation: "consulta_medicoes_obra",
            der_measurement_response_path: "consulta_medicoes_obra_response/lista_medicoes_obra/medicao_obra",

            dae_operation: 'consulta_obras',
            dae_response_path: 'consulta_obras_response/lista_obras/obra',

            dae_measurement_operation: "consulta_obra_medicao",
            dae_measurement_response_path: "consulta_obra_medicao_response/lista_obras_medicoes/obra_medicao",

            dae_photo_operation: "consulta_foto_medicao",
            dae_photo_response_path: "consulta_foto_medicao_response/lista_foto_medicao/foto_medicao",

            der_coordinates_operation: "consulta_obra_por_numero_contrato_sacc",
            der_coordinates_response_path: "consulta_obra_por_numero_contrato_sacc_response/obra_por_numero_contrato_sacc"
          }

        # domingos 4:00 am
        schedule_attributes = { cron_syntax_frequency: '0 * * 4 0' }

        configuration = Integration::Constructions::Configuration.first_or_initialize

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
    # RAILS_ENV=production nohup rake integration:constructions:import &
    #
    task import: :environment do
      configuration = Integration::Constructions::Configuration.last
      Integration::Constructions::Importer.call(configuration.id)
    end
  end
end
