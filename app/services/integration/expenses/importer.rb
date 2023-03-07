#
# Importador integrado de despesas (NPF -> NED -> NLD -> NPD)
#
class Integration::Expenses::Importer
  include LogImporter

  IMPORTERS = [
    Integration::Expenses::NpfImporter,
    Integration::Expenses::NedImporter,
    Integration::Expenses::NldImporter,
    Integration::Expenses::NpdImporter,
    Integration::Expenses::BudgetBalanceImporter
  ]

  attr_reader :configuration, :client, :logger

  def self.call(configuration_id)
    new(configuration_id).call
  end

  def initialize(configuration_id)
    @configuration = configuration_class.find(configuration_id)
    @logger = Logger.new(log_path) if @logger.nil?
  end

  def call

    start

    success = true
    errors = ''

    # pré-instancia os importers para que a data fique registrada e importadores
    # não dependam de 'configuration'. Pois, no meio do processo de importação,
    # o model 'configuration' pode ser alterado via script ou admin.

    importer_instances = IMPORTERS.map {|klass| klass.new(configuration, @logger)}.compact

    importer_instances.each do |importer|
      begin
        importer.call
      rescue StandardError => e
        success = false
        errors += "#{importer.class.name}: #{e.message}\n"
      end
    end

    if success
      @configuration.status_success!
    else
      log(:error, I18n.t('services.importer.log.error', e: errors))
      @configuration.status_fail!
    end

    close_log
  end

  private

  def configuration_class
    Integration::Expenses::Configuration
  end
end
