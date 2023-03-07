namespace :ppa do
  namespace :source do

    def ppa_source_clear__rake_task!
      PPA::Source::Guideline.destroy_all
      PPA::Source::AxisTheme.destroy_all
      PPA::Source::Region.destroy_all
    end

    def ppa_source_load__rake_task!
      import_tasks = [
        'integration:ppa:source:region:import',
        'integration:ppa:source:axis_theme:import',
        'integration:ppa:source:guideline:import'
      ]

      import_tasks.each { |task_name| Rake::Task[task_name].invoke }
    end

    desc 'Destroys all PPA imported source data (from webservices)'
    task clear: :environment do |task|
      logger = Logger.new STDOUT, progname: "rake #{task.name}", level: :info
      Rails.logger = logger
      ActiveRecord::Base.logger = logger

      logger.info "starting..."

      ppa_source_clear__rake_task!

      logger.info "complete"
    end

    desc 'Loads all PPA source data, importing from webservices'
    task load: :environment do |task|
      logger = Logger.new STDOUT, progname: "rake #{task.name}", level: :info
      Rails.logger = logger
      ActiveRecord::Base.logger = logger

      logger.info "starting..."

      ppa_source_load__rake_task!

      logger.info "complete"
    end

    desc 'Resets all PPA imported source data, destroying and re-creating/importing it all'
    task reset: :environment do |task|
      logger = Logger.new STDOUT, progname: "rake #{task.name}", level: :info
      Rails.logger = logger
      ActiveRecord::Base.logger = logger

      logger.info "starting..."

      ppa_source_clear__rake_task!
      ppa_source_load__rake_task!

      logger.info "complete"
    end

  end
end
