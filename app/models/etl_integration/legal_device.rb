#
# Tabela Base
#
# Dispositivo Legal
#

class EtlIntegration::LegalDevice < ApplicationEtlIntegrationRecord

  self.table_name = "sefaz_rest.dispositivo_legal"

  FROM_TO = {
    titulo: :descricao
  }

end
