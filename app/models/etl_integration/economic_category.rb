#
# Tabela Base
#
# Categoria Econômica
#

class EtlIntegration::EconomicCategory < ApplicationEtlIntegrationRecord

  self.table_name = "sefaz_rest.categoria_economica"

  FROM_TO = {
    codigo: :codigo_categoria_economica
  }

end