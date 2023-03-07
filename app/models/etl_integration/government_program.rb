#
# Tabela Base
#
# Programa Governamental
#

class EtlIntegration::GovernmentProgram < ApplicationEtlIntegrationRecord

  self.table_name = "sefaz_rest.programa_governo"

  FROM_TO = {
    codigo: :codigo_programa
  }

end
