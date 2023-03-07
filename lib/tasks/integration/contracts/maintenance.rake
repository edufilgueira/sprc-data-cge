namespace :integration do
  namespace :contracts do
    namespace :maintenance do

      def fix_convenant
        convenants = Stats::Contracts::Convenant
          .group(:month, :year).order(:year, :month).count.map do |keys, value|
            { month: keys.first, year: keys.last }
          end

        convenants.each do |convenant|
          p "Atualizando Convenios de #{convenant[:month]}/#{convenant[:year]}.."
          Integration::Contracts::Convenants::CreateStats
            .call(convenant[:year], convenant[:month])
        end
      end

      def fix_contracts
        contracts = Stats::Contracts::Contract
          .group(:month, :year).order(:year, :month).count.map do |keys, value|
            { month: keys.first, year: keys.last }
          end

        contracts.each do |contract|
          p "Atualizando Contratos de #{contract[:month]}/#{contract[:year]}.."
          Integration::Contracts::Contracts::CreateStats
            .call(contract[:year], contract[:month])
        end
      end

      task reprocessing_stats_of_contracts_and_convenents: :environment do
        fix_convenant
        fix_contracts
      end

      desc "Deletar Todos os Dados do Financeiro por Ano ou Ano/Mês do Documento (tabela integration_contracts_financials )"
      task :delete_financials_by_ano_or_mes_documento, [:mes_documento, :ano_documento] => :environment do |t, args|

        if args.mes_documento and (args.mes_documento.to_i.in? Array.new(12) {|i| i+1 }) and args.ano_documento
          puts "-- Deleção de registros iniciada para o mês/ano #{args.mes_documento}/#{args.ano_documento} --"

          response = Integration::Contracts::Financial.destroy_all(
            "ano_documento = '#{args.ano_documento}' 
            AND EXTRACT (MONTH FROM data_documento) = '#{args.mes_documento}' "
          )

          puts "-- Total de registros deletados do mês/ano #{args.mes_documento}/#{args.ano_documento}: #{response.count} --"
          puts "-- Deleção de registros finalizada para o mês/ano #{args.mes_documento}/#{args.ano_documento} --"

        elsif args.ano_documento and args.ano_documento.size == 4 and args.mes_documento.to_i == 0
          puts "-- Deleção de registros iniciada para o ano #{args.ano_documento} --"
          
          response = Integration::Contracts::Financial.destroy_all(ano_documento: "#{args.ano_documento}")

          puts "-- Total de registros deletados do ano #{args.ano_documento}: #{response.count} --"
          puts "-- Deleção de registros finalizada para o ano #{args.ano_documento} --"
        else
          raise "### ERRO: Parâmetro Inválido, favor informar o mês e ano ou '0' e ano que deseja deletar"
        end
      end #/task :delete_financials_by_ano_documento

    end
  end
end
