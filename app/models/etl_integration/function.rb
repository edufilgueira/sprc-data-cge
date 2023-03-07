#
# Tabela Base
#
# Função
#

class EtlIntegration::Function < ApplicationEtlIntegrationRecord

  self.table_name = "sefaz_rest.funcao"

  FROM_TO = {
    codigo: :codigo_funcao
  }

end