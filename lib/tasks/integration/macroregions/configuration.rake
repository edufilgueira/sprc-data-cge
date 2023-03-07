namespace :integration do
  namespace :macroregions do

    # RAILS_ENV=production rake integration:macroregions:configuration:create_or_update
    namespace :configuration do
      task create_or_update: :environment do
        attributes = {
          user: 'caiena',
          password: '-',
          headers_soap_action: '',
          wsdl: 'http://integracao.cge.ce.gov.br/cge-integracao/InvestimentoMacroregiaoService?wsdl',
          operation: 'consultar_investimentos_macroregiao',
          response_path: 'consultar_investimentos_macroregiao_response/lista_investimentos_macroregiao/investimentos_macroregiao',
          year: Date.today.year
        }

        configuration = Integration::Macroregions::Configuration.first_or_initialize

        # todo dia 1 as 2:00a.m
        schedule_attributes = { cron_syntax_frequency: '0 2 1 * *' }

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
    # RAILS_ENV=production nohup rake integration:macroregions:import &
    #
    task import: :environment do
      configuration = Integration::Macroregions::Configuration.last

      begin_year = 2015
      current_year = Date.current.year

      (begin_year..current_year).each do |year|
        powers.each do |power|
          configuration.update_attributes(year: year, power: power.code)

          Integration::Macroregions::Importer.call(configuration.id)
        end
      end
    end

    def powers
      power_data = [
        {
          code: '1',
          name: 'LEGISLATIVO'
        },
        {
          code: '2',
          name: 'JUDICIÁRIO'
        },
        {
          code: '3',
          name: 'MINISTÉRIO PUBLICO'
        },
        {
          code: '4',
          name: 'EXECUTIVO'
        },
        {
          code: '5',
          name: 'EXECUTIVO AUTONOMO (DEFENSORIA PÚBLICA)'
        },
      ]

      power_data.each do |data|
        power = Integration::Macroregions::Power.find_or_initialize_by(code: data[:code], name: data[:name])

        power.save
      end

      Integration::Macroregions::Power.all
    end
  end
end
