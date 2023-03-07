class Integration::Supports::Theme::Importer < Integration::Supports::BaseSupportsImporter

  private

  def importer_id
    :theme
  end

  def configuration_class
    Integration::Supports::Theme::Configuration
  end

  def resource_class
    Integration::Supports::Theme
  end

  def resource_finder_params(attributes)
    {
      codigo_tema: attributes[:codigo_tema]
    }
  end
end
