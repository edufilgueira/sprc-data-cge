#
# Tabela Base
#
# Modalidade de Aplicação
#

class EtlIntegration::ApplicationModality < ApplicationEtlIntegrationRecord

  self.table_name = "sefaz_rest.modalidade_aplicacao"

  FROM_TO = {
    codigo: :codigo_modalidade
  }

end