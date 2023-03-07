#
# Tabela Base
#
# Subfunção
#

class EtlIntegration::SubFunction < ApplicationEtlIntegrationRecord

  self.table_name = "sefaz_rest.subfuncao"

  FROM_TO = {
    codigo: :codigo_sub_funcao
  }

end