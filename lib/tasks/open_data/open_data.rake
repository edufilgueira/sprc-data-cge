#
# Rake para importar dados relacionados aos Dados Abertos.
#

namespace :open_data do
  task :create_or_update => :environment do

    # tasks

    tasks = [
      'open_data:vcge_categories:create_or_update'
    ]

    tasks.each { |task| Rake::Task[task].invoke }
  end
end
