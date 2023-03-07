#
# Rake para importar dados de integração.
#

namespace :integration do
  namespace :configurations do
    task :create_or_update => :environment do

      # tasks

      tasks = [
        'integration:constructions:configuration:create_or_update',
        'integration:contracts:configuration:create_or_update',
        'integration:eparcerias:configuration:create_or_update',
        'integration:expenses:configuration:create_or_update',
        'integration:purchases:configuration:create_or_update',
        'integration:revenues:configuration:create_or_update',
        'integration:servers:configuration:create_or_update',
        'integration:real_states:configuration:create_or_update',
        'integration:supports:creditors:configuration:create_or_update',
        'integration:supports:domain:configuration:create_or_update',
        'integration:supports:organs:configuration:create_or_update',
        'integration:supports:axis:configuration:create_or_update',
        'integration:supports:theme:configuration:create_or_update',
        'integration:results:configuration:create_or_update',
        'integration:ppa::source:region:create_or_update',
        'integration:ppa::source:axis:create_or_update',
        'integration:ppa::source:theme:create_or_update',
        'integration:ppa::source:guideline:create_or_update'
      ]

      tasks.each { |task| Rake::Task[task].invoke }
    end
  end

  task :import => :environment do
    # tasks

    tasks = [
      'integration:constructions:import',
      'integration:contracts:import',
      'integration:eparcerias:import',
      'integration:expenses:import',
      'integration:purchases:import',
      'integration:revenues:import',
      'integration:servers:import',
      'integration:servers:proceed_types:create_or_update',
      'integration:real_states:import',
      'integration:supports:creditors:import',
      'integration:supports:organs:import',
      'integration:supports:axis:import',
      'integration:supports:theme:import',
      'integration:results:import',
      'integration:ppa::source:region:import',
      'integration:ppa::source:axis:import',
      'integration:ppa::source:theme:import',
      'integration:ppa::source:guideline:import'
    ]


    tasks.each { |task| Rake::Task[task].invoke }
  end
end
