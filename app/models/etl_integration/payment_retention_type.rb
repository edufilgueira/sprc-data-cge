#
# Tabela Base
#
# Tipo de Retenção de Pagamento
#

class EtlIntegration::PaymentRetentionType < ApplicationEtlIntegrationRecord

  self.table_name = "sefaz_rest.tipo_retencao"

  FROM_TO = {
    codigo: :codigo_retencao
  }

end