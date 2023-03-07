#
# Tabela Base
#
# Grupo da Natureza da Despesa
#

class EtlIntegration::ExpenseNatureGroup < ApplicationEtlIntegrationRecord

  self.table_name = "sefaz_rest.grupo_natureza_despesa"

  FROM_TO = {
    codigo: :codigo_grupo_natureza
  }

end