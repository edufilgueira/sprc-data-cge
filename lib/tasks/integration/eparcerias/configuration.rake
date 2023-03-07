namespace :integration do
  namespace :eparcerias do
    namespace :configuration do
      task create_or_update: :environment do

        attributes =
          {
            user: 'caiena',
            password: '-',
            headers_soap_action: '',

            wsdl: 'http://integracao.cge.ce.gov.br/cge-integracao/EparceriasService?wsdl',

            transfer_bank_order_operation: "consulta_ordens_bancarias",
            transfer_bank_order_response_path: "consulta_ordens_bancarias_response/lista_ordem_bancaria/ordem_bancaria",

            work_plan_attachment_operation: "consulta_anexos_plano_trabalho",
            work_plan_attachment_response_path: "consulta_anexos_plano_trabalho_response/lista_anexo_plano_trabalho/anexo_arquivo",

            accountability_operation: "consulta_situacao_prestacao_contas",
            accountability_response_path: "consulta_situacao_prestacao_contas_response/situacao_prestacao_contas",

            import_type: :import_all
          }


        configuration = Integration::Eparcerias::Configuration.first_or_initialize

        # domingos 4:00 am
        schedule_attributes = { cron_syntax_frequency: '0 * * 4 0' }


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
    # RAILS_ENV=production nohup rake integration:eparcerias:import &
    #
    task import: :environment do
      configuration = Integration::Eparcerias::Configuration.last
      Integration::Eparcerias::Importer.call(configuration.id)
    end

    # Rodar em segundo plano
    # RAILS_ENV=production nohup rake integration:eparcerias:daily_update &
    #
    task daily_update: :environment do

      # Atualização diária pega apenas os contratos ativos.

      configuration = Integration::Eparcerias::Configuration.last

      old_value = configuration.import_all?

      configuration.update_column(:import_all, false)

      importer = Integration::Eparcerias::Importer.new(configuration.id)

      configuration.update_column(:import_all, old_value)

      importer.call
    end

    # Rodar em segundo plano
    # RAILS_ENV=production nohup rake integration:eparcerias:weekly_update &
    #
    task weekly_update: :environment do

      # Atualização semanal pega todos.

      configuration = Integration::Eparcerias::Configuration.last

      old_value = configuration.import_all?

      configuration.update_column(:import_all, true)

      importer = Integration::Eparcerias::Importer.new(configuration.id)

      configuration.update_column(:import_all, old_value)

      importer.call
    end
  end
end
