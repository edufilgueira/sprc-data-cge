#
# Importador integrado de construções (DER/DAE)
#
class Integration::Constructions::Importer
  include LogImporter

  attr_reader :configuration

  def self.call(configuration_id)
    new(configuration_id).call
  end

  def initialize(configuration_id)
    @configuration = Integration::Constructions::Configuration.find(configuration_id)
  end

  def call

    start

    begin

      call_der
      call_dae

      close_log
      @configuration.status_success!

    rescue StandardError => e
      log(:error, I18n.t('services.importer.log.error', e: e.message))

      close_log
      @configuration.status_fail!
    end
  end

  private

  def call_der
    Integration::Constructions::DerImporter.call(configuration, @logger)
  end

  def call_dae
    Integration::Constructions::DaeImporter.call(configuration, @logger)
  end

end
