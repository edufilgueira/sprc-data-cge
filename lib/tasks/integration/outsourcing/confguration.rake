namespace :integration do
  namespace :outsourcing do
    namespace :configuration do
      task create_or_update: :environment do
        attributes = {
          wsdl: 'http://integracao.cge.ce.gov.br/cge-integracao/SrvEntidadesService?wsdl',
          headers_soap_action: nil,
          user: 'caiena',
          password: '-',
          entity_operation: 'consultar_srv_entidades',
          entity_response_path: 'consultar_srv_entidades_response/entidade_item_array/entidade_item',
          monthly_cost_operation: 'consultar_srv_faturamento_mensal',
          monthly_cost_response_path: 'consultar_srv_faturamento_mensal_response/faturamento_mensal_item_array/faturamento_mensal_item',
          month: '9/2019'
        }

        configuration = Integration::Outsourcing::MonthlyCosts::Configuration.first_or_initialize

        # todo dia 1 as 00:00a.m
        schedule_attributes = { cron_syntax_frequency: '0 0 1 * *' }

        # Não altera configurações já existentes.
        if configuration.new_record?
          configuration.assign_attributes(attributes)

          configuration.build_schedule
          configuration.schedule.assign_attributes(schedule_attributes)

          configuration.save!
        end
      end
    end
  end
end
