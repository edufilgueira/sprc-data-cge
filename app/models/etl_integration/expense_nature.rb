#
# Tabela Base
#
# Natureza da Despesa
#

class EtlIntegration::ExpenseNature < ApplicationEtlIntegrationRecord

  self.table_name = "sefaz_rest.natureza_despesa"

  FROM_TO = {
    codigo: :codigo_natureza_despesa
  }

end