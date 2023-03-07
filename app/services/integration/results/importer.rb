#
# Importador de dados do Web service de Indicadores estratégicos
#
class Integration::Results::Importer
  include LogImporter

  attr_reader :configuration

  def self.call(configuration_id)
    new(configuration_id).call
  end

  def initialize(configuration_id)
    @configuration = Integration::Results::Configuration.find(configuration_id)
  end

  def call

    start

    begin
      call_strategic_indicator
      call_thematic_indicator

      close_log
      @configuration.status_success!

    rescue StandardError => e
      log(:error, I18n.t('services.importer.log.error', e: e.message))

      close_log
      @configuration.status_fail!
    end
  end

  private

  def call_strategic_indicator
    Integration::Results::StrategicIndicatorsImporter.call(configuration, @logger)
  end

  def call_thematic_indicator
    Integration::Results::ThematicIndicatorsImporter.call(configuration, @logger)
  end
end
