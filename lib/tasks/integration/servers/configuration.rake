namespace :integration do
  namespace :servers do
    namespace :configuration do

      # Cria o configurador padrão
      task create_or_update: :environment do
        configuration_server_data = {
          arqfun_ftp_address: "ftp.cge.ce.gov.br",
          arqfun_ftp_dir: "/",
          arqfun_ftp_user: "seplag",
          arqfun_ftp_password: "-",
          arqfin_ftp_address: "ftp.cge.ce.gov.br",
          arqfin_ftp_dir: "/",
          arqfin_ftp_user: "seplag",
          arqfin_ftp_password: "-",
          rubricas_ftp_address: "ftp.cge.ce.gov.br",
          rubricas_ftp_dir: "/",
          rubricas_ftp_user: "seplag",
          rubricas_ftp_password: "-"
        }

        configuration = Integration::Servers::Configuration.first_or_initialize

        # todo dia 5 as 2:00a.m
        schedule_attributes = { cron_syntax_frequency: '0 2 5 * *' }

        # Não altera configurações já existentes.
        if configuration.new_record?
          configuration.assign_attributes(configuration_server_data)

          configuration.build_schedule
          configuration.schedule.assign_attributes(schedule_attributes)

          configuration.save!
        end
      end
    end

    # Importa os dados
    # Rodar em segundo plano
    #
    # cd /app/sprc-data/current && RAILS_ENV=production nohup bundle exec rake integration:servers:server_salaries:import &
    #
    namespace :server_salaries do
      task import: :environment do
        configuration = Integration::Servers::Configuration.last

        old_month = configuration.month

        # Devemos dividir em pequenas porções filtradas por período para evitar o readtimeout
        periods = {
          2019 => (1..1),
          2018 => (1..12),
          2017 => (1..12),
          2016 => (1..12)
        }

        periods.each do |year, months|
          m = (months.blank? ? (1..12) : months).to_a

          m.reverse_each.each do |month|
            month = "#{month}/#{year}"

            Integration::Servers::ServerSalary.from_date(month.to_date).delete_all

            configuration.update_attributes(month: month)

            importer = Integration::Servers::ServerSalaries::CreateServerSalaries.new(month, configuration)

            importer.call
          end
        end

        configuration.update_attributes(month: old_month)
      end
    end
  end
end
