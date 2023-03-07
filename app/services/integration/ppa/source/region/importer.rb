#
# Importador de Regioes do PPA
#
class Integration::PPA::Source::Region::Importer < Integration::PPA::Source::BaseImporter

  private

  def importer_id
    :ppa_source_region
  end

  def configuration_class
    Integration::PPA::Source::Region::Configuration
  end

  def resource_class
    ::PPA::Source::Region
  end

  def resource_finder_params(attributes)
    {
      codigo_regiao: attributes[:codigo_regiao]
    }
  end
end
