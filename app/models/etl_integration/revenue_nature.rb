#
# Tabela Base
#
# Natureza da Receita
#

class EtlIntegration::RevenueNature < ApplicationEtlIntegrationRecord

  self.table_name = "sefaz_rest.natureza_receita"

  FROM_TO = {
    ano: :year,
    titulo: :descricao
  }

end