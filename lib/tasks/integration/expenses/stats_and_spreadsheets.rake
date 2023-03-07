namespace :integration do
  namespace :expenses do
    namespace :stats_and_spreadsheets do

      # Comandos para rodar em prod:
      # - cd /app/sprc-data/current/
      # - RAILS_ENV=production nohup bundle exec rake integration:expenses:stats_and_spreadsheets:create_or_update &
      task create_or_update: :environment do

        #
        # stats
        #
        first_year = 2012
        last_year = Date.today.year

        (first_year..last_year).each do |year|
          last_month = (year == last_year) ? Date.today.month : 12
          (1..last_month).each do |month_start|
            (month_start..last_month).each do |month_end|
              month_range = { month_start: month_start, month_end: month_end }

              Integration::Expenses::BudgetBalances::CreateStats.call(year, 0, month_range)
            end
          end
        end

        #
        # spreadsheets
        #
        (first_year..last_year).each do |year|
          last_month = (year == last_year) ? Date.today.month : 12
          (1..last_month).each do |month_start|
            (month_start..last_month).each do |month_end|
              month_range = { month_start: month_start, month_end: month_end }

              Integration::Expenses::BudgetBalances::CreateSpreadsheet.call(year, 0, month_range)
            end
          end
        end
      end
    end
  end
end
