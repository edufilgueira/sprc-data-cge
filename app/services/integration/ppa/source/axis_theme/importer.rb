#
# Importador de EixosTema do PPA
#
class Integration::PPA::Source::AxisTheme::Importer < Integration::PPA::Source::BaseImporter

  private

  def importer_id
    :ppa_source_axis_theme
  end

  def configuration_class
    Integration::PPA::Source::AxisTheme::Configuration
  end

  def resource_class
    ::PPA::Source::AxisTheme
  end

  def resource_finder_params(attributes)
    {
      codigo_eixo: attributes[:codigo_eixo],
      codigo_tema: attributes[:codigo_tema]
    }
  end
end
