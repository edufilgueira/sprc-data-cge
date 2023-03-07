  #
  # Rake para manutenção de Credores.
  #
  #

  namespace :integration do
    namespace :supports do
      namespace :creditors do
        namespace :maintenance do
          desc 'Delete duplicates'
          task :delete_duplicates => :environment do |t|
            puts '---------------------------------------------'
            creditors = Integration::Supports::Creditor.group(
              :codigo
            ).having('count(codigo) > 1')

            if creditors.any?
              creditors.pluck(:codigo).each do |codigo_cred|
                # o último registro não pode ser excluído, pode se tratar de uma
                # atualização de dados
                Integration::Supports::Creditor.where(
                  codigo: codigo_cred
                ).where.not(
                  id: last_occurrence_code_id(codigo_cred)
                ).delete_all

                puts "Credor ID: #{ last_occurrence_code_id(codigo_cred) } DELETADO - Código #{ codigo_cred }"
              end
            else
              puts '----- Não possui Credores Duplicados -----'
            end

          end
          
          def last_occurrence_code_id(codigo)
            Integration::Supports::Creditor.where(codigo: "#{codigo}").last.id
          end

        end
      end
    end
  end