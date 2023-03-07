module Integration::Constructions::BaseImporter
  include BaseIntegrationsImporter


  protected

  def import(kind)

    line = 0

    resources(kind).each do |attributes|

      line += 1

      send("import_#{kind}", attributes, line)

    end

    log(:info, I18n.t("services.importer.log.#{kind}", line: line))

  end

  def message(prefix)
    default_message.merge({ filtro: '' })
  end

  def normalized_attributes(attributes)
    attributes[:longitude] = normalize_longitude(attributes[:longitude])
    attributes
  end

  def normalize_longitude(longitude)
    longitude.insert(0, '-') if longitude && longitude[0] != '-'
    longitude
  end
end
