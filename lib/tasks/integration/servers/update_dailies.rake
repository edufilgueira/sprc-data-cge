namespace :integration do
  namespace :servers do

    # Importa os dados
    # Rodar em segundo plano
    #
    # cd /app/sprc-data/current && RAILS_ENV=production nohup bundle exec rake integration:servers:server_salaries:update_dailies &
    #
    namespace :server_salaries do
      task update_dailies: :environment do

        periods = {
          2019 => (1..1),
          2018 => (1..12),
          2017 => (1..12),
          2016 => (6..12)
        }

        periods.each do |year, months|
          months.reverse_each do |month|
            month_year = "#{month}/#{year}"

            # Atualiza as diárias do mes e a planilha
            updater = Integration::Servers::ServerSalaries::UpdateIncomeDailies.new(month_year, nil, false, true)

            updater.logger.info("[SERVERS] [update_dailies] Atualizando diárias dos salários de #{month_year}")

            updater.call
          end
        end

        # Atualiza todas as estatísticas no fim
        updater = Integration::Servers::ServerSalaries::UpdateIncomeDailies.new(0, nil, true, false)

        updater.logger.info('[SERVERS] [update_dailies] Atualizando todas as planilhas')

        updater.call

        updater.logger.info('[SERVERS] [update_dailies] DONE')
      end
    end
  end
end
