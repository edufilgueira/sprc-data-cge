class Integration::Supports::Creditor::Importer < Integration::Supports::BaseSupportsImporter

  private

  def importer_id
    :creditor
  end

  def configuration_class
    Integration::Supports::Creditor::Configuration
  end

  def resource_class
    Integration::Supports::Creditor
  end

  def resource_finder_params(attributes)
    { codigo: attributes[:codigo] }
  end

  def message
    # a mensagem padrão possue usuário e senha.
    super.merge(
      filtro: {
        data_inicio: start_at,
        data_fim: finished_at,
        pagina: ''
      })
  end

  def start_at
    @configuration.started_at.present? ? @configuration.started_at.to_s : Date.yesterday.to_s
  end

  def finished_at
    @configuration.finished_at.present? ? @configuration.finished_at.to_s : Date.today.to_s
  end
end
