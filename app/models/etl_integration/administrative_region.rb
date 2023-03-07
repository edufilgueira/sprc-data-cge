#
# Tabela Base
#
# Região Administrative
#

class EtlIntegration::AdministrativeRegion < ApplicationEtlIntegrationRecord

  self.table_name = "sefaz_rest.regiao_administrativa"

  FROM_TO = {
    codigo: :codigo_regiao
  }

end
