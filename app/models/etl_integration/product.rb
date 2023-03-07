#
# Tabela Base
#
# Produtos
#

class EtlIntegration::Product < ApplicationEtlIntegrationRecord

  self.table_name = "sefaz_rest.produto"

  FROM_TO = {
    codigo: :codigo
  }

end