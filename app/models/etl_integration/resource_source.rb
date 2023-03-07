#
# Tabela Base
#
# Fonte de Recurso
#

class EtlIntegration::ResourceSource < ApplicationEtlIntegrationRecord

  self.table_name = "sefaz_rest.fonte_recurso"

  FROM_TO = {
    codigo: :codigo_fonte
  }

end