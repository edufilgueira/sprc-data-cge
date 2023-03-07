class Integration::Supports::Axis::Importer < Integration::Supports::BaseSupportsImporter

  private

  def importer_id
    :axis
  end

  def configuration_class
    Integration::Supports::Axis::Configuration
  end

  def resource_class
    Integration::Supports::Axis
  end

  def resource_finder_params(attributes)
    {
      codigo_eixo: attributes[:codigo_eixo]
    }
  end
end
