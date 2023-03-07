# Rodar em segundo plano
# RAILS_ENV=production nohup rake domains_importer:create_or_update &
#

namespace :domains_importer do
  task create_or_update: :environment do

    domain_configuration = Integration::Supports::Domain::Configuration.last

    begin_year = 2010
    current_year = Date.current.year

    old_year = domain_configuration.year

    (begin_year..current_year).reverse.each do |year|
      importer = Integration::Supports::Domain::Importer.new(domain_configuration.id)
      domain_configuration.update_attributes(year: year)

      logger = importer.logger

      logger.info("[SUPPORTS::DOMAIN] Importando: #{year}")

      importer.call
    end

    domain_configuration.update_attributes(year: old_year)
  end
end
