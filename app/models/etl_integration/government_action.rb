#
# Tabela Base
#
# Ação Governamental
#

class EtlIntegration::GovernmentAction < ApplicationEtlIntegrationRecord

  self.table_name = "sefaz_rest.acao"

  FROM_TO = {
    codigo: :codigo_acao
  }

end
