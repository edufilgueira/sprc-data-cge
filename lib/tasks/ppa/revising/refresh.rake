namespace :ppa do
  namespace :revising do
    # rake ppa:revising:refresh
    desc 'Remove e insere os dados na tabela AxisThemeObjectiveStrategies do SPRC-DATA'
    task refresh: :environment do |task|
      year = 2020

      logger = Logger.new STDOUT, progname: "rake #{task.name}", level: :info
      Rails.logger = logger
      ActiveRecord::Base.logger = logger

      logger.info "starting..."

      Integration::PPA::Source::AxisThemeObjectiveStrategy.where(ppa_ano_inicio: year).destroy_all
      Integration::PPA::Source::AxisThemeObjectiveStrategy::Importer.call(1)

      logger.info "complete"
    end
  end
end
