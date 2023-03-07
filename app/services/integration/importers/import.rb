#
# Serviço responsável por invocar importadores recebidos via API (sprc)
#
class Integration::Importers::Import

  CONFIGURATION_CLASSES = {
    city_undertakings: Integration::CityUndertakings::Configuration,
    constructions: Integration::Constructions::Configuration,
    contracts: Integration::Contracts::Configuration,
    eparcerias: Integration::Eparcerias::Configuration,
    expenses: Integration::Expenses::Configuration,
    open_data: OpenData::DataItem,
    outsourcing_monthly_costs: Integration::Outsourcing::MonthlyCosts::Configuration,
    purchases: Integration::Purchases::Configuration,
    real_states: Integration::RealStates::Configuration,
    revenues: Integration::Revenues::Configuration,
    servers: Integration::Servers::Configuration,
    supports_creditor: Integration::Supports::Creditor::Configuration,
    supports_domain: Integration::Supports::Domain::Configuration,
    supports_organ: Integration::Supports::Organ::Configuration,
    supports_axis: Integration::Supports::Axis::Configuration,
    supports_theme: Integration::Supports::Theme::Configuration,
    results: Integration::Results::Configuration,
    # --
    # PPA
    # --
    ppa_source_axis_theme: Integration::PPA::Source::AxisTheme::Configuration,
    ppa_source_region: Integration::PPA::Source::Region::Configuration,
    ppa_source_guideline: Integration::PPA::Source::Guideline::Configuration,
    # --
    # PPA
    # --
    macroregions: Integration::Macroregions::Configuration
  }

  attr_accessor :configuration_class_alias, :configuration_id

  def self.call(configuration_class_alias, configuration_id)
    new(configuration_class_alias, configuration_id).call
  end

  def call
    call_importer(configuration_class_alias, configuration_id)
  end

  def initialize(configuration_class_alias, configuration_id)
    @configuration_class_alias = configuration_class_alias
    @configuration_id = configuration_id
  end

  private

  def call_importer(configuration_class_alias, configuration_id)
    configuration.status_queued!

    # O próprio .import do configuration aciona o delay

    configuration.import
  end

  def configuration
    configuration_class.find(configuration_id)
  end

  def configuration_class
    CONFIGURATION_CLASSES.with_indifferent_access[configuration_class_alias]
  end
end
