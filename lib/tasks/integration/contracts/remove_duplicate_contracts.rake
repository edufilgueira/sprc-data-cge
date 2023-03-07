

namespace :integration do
  namespace :contracts do
    namespace :duplicate_contracts do

      desc "Deletar Contratos repetidos"

      # t1.ctid < t2.ctid -- deleta contratos duplicados mais antigos
      # t1.isn_sic = t2.isn_sic -- regra de unicidade para delecao
      task remove_duplicate_contracts: :environment do |t, args|
        sql = 'DELETE FROM integration_contracts_contracts t1
                     USING integration_contracts_contracts t2
                     WHERE t1.ctid < t2.ctid
                       AND t1.isn_sic = t2.isn_sic;'
        ap ActiveRecord::Base.connection.execute(sql)
      end
    end
  end
end
