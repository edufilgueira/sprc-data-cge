#
# Tabela Base
#
# Credores
#

class EtlIntegration::Creditor < ApplicationEtlIntegrationRecord

  self.table_name = "sefaz_rest.credor"

  FROM_TO = {
    codigo: :cpf_cnpj
  }
end