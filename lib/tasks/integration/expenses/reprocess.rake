namespace :integration do
  namespace :expenses do
    namespace :reprocess do

      # Comandos para rodar em prod:
      # - cd /app/sprc-data/current/
      # - RAILS_ENV=production nohup bundle exec rake integration:expenses:reprocess:budgetbalance  monthyear='12/2021' &

      task budgetbalance: :environment do

        ENV['BYPASS_SPREADSHEETS'] = 'true'

        month = ENV['monthyear'].split('/')[0].to_i
        year = ENV['monthyear'].split('/')[1].to_i

        month_str = month.to_s.rjust(2, '0')

        start = Date.new(year, month, 1)
        finish = start.end_of_month  
        month_year = "#{month_str}-#{year}"

        Integration::Expenses::BudgetBalance.where(ano_mes_competencia: month_year).delete_all

        conf = Integration::Expenses::Configuration.first
        conf.update(started_at: start, finished_at: finish)

        logger = Logger.new("/tmp/reprocess_budgetbalance.log")

        Integration::Expenses::BudgetBalanceImporter.call(conf, logger)
        logger.info('Fim do Processamento')
      end
    end
  end
end
