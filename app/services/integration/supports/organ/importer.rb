#
# Importador de Órgãos via web service
#
class Integration::Supports::Organ::Importer < Integration::Supports::BaseSupportsImporter

  private

  def importer_id
    :organ
  end

  def configuration_class
    Integration::Supports::Organ::Configuration
  end

  def resource_class
    Integration::Supports::Organ
  end

  def resource_finder_params(attributes)
    {
      codigo_orgao: attributes[:codigo_orgao],
      codigo_folha_pagamento: attributes[:codigo_folha_pagamento],
      data_termino: attributes[:data_termino]
    }
  end
end
