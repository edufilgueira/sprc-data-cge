class Integration::PPA::Source::BaseImporter
  include BaseIntegrationsImporter

  attr_reader :configuration, :client, :logger

  def self.call(configuration_id)
    new(configuration_id).call
  end

  def initialize(configuration_id)
    @configuration = configuration_class.find(configuration_id)
    @client = client_connection(@configuration.wsdl, @configuration.headers_soap_action)
    @logger = Logger.new(log_path) if @logger.nil?
  end

  def call
    import
  end

  private

  def import
    start

    begin
      line = 0

      resources.each do |attributes|
        line += 1
        import_resource(attributes, line)
      end

      log(:info, I18n.t("services.importer.log.#{importer_id}", line: line))
      close_log
      @configuration.status_success!

    rescue StandardError => e
      log(:error, I18n.t('services.importer.log.error', e: e.message))
      close_log
      @configuration.status_fail!
    end
  end

  def import_resource(attributes, line)
    resource = resource_class.find_or_initialize_by(resource_finder_params(attributes))

    update(resource, attributes, line)
  end

  def message
    {
      usuario: @configuration.user,
      senha: @configuration.password
    }
  end
end
