module Integration::Results::BaseImporter
  include BaseIntegrationsImporter


  protected

  def import(kind)
    line = 0

    resources(kind).each do |attributes|
      return if attributes.blank?

      line += 1

      send("import_#{kind}", attributes, line)

    end

    log(:info, I18n.t("services.importer.log.#{kind}", line: line))
  end

  def message(_prefix)
    default_message
  end
end
