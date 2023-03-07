#
# Rake para importar os dados necessários para a aplicação estar pronta para
# o desenvolvimento.
#
# Tasks:
#
# - setup: carrega os dados necessários sem limpar o banco de dados;
# - reset: recria o banco de dados e carrega os dados iniciais;
#

namespace :application do

  def confirm_reset?
    STDOUT.flush
    input = STDIN.gets.chomp

    (input.downcase === 'yes')
  end

  desc 'Setup application'
  task :setup => :environment do

    # tasks

    tasks = [
      'integration:configurations:create_or_update',
      'open_data:create_or_update'
    ]

    tasks.each { |task| Rake::Task[task].invoke }
  end

  desc 'Reset application'
  task :reset => :environment do

    puts '[ATENÇÃO] essa rake irá APAGAR O BANCO DE DADOS, tem certeza? (yes para continuar).'

    unless confirm_reset?
      exit
    end

    # tasks

    tasks = [
      'db:drop',
      'db:create',
      'db:migrate',
      'application:setup'
    ]

    tasks.each { |task| Rake::Task[task].invoke }
  end
end
