#
# Importador de dados do Web Service de Compras
#
class Integration::Purchases::Importer < Integration::Supports::BaseSupportsImporter

  attr_reader :reference_month

  def initialize(configuration_id)
    super

    # Precisamos guardar o valor do mês antes, e não depender mais do
    # configuration, para permitir que outros processo de
    # importação rodem paralelo e que as estatísticas/planilhas, criadas no
    # final do processo, sejam geradas com a data esperada.

    @reference_month = @configuration.month.present? ? Date.parse(@configuration.month) : Date.current.last_month
  end

  def call
    start

    begin
      import_purchases

      close_log
      @configuration.status_success!

    rescue StandardError => e
      log(:error, I18n.t('services.importer.log.error', e: e.message))

      close_log
      @configuration.status_fail!
    end
  end

  protected

  def import_purchases
    import
    create_stats
    create_spreadsheet
  end

  def import
    line = 0

    resources.each do |attributes|
      line += 1
      import_purchase(attributes, line)
    end

    log(:info, I18n.t("services.importer.log.purchase", line: line))
  end

  private

  def create_stats
    Integration::Purchases::CreateStats.call(reference_month.year, reference_month.month)
  end

  def create_spreadsheet
    Integration::Purchases::CreateSpreadsheet.call(reference_month.year, reference_month.month)
  end

  def import_purchase(attributes, line)
    purchase = purchase(attributes)
    update(purchase, attributes, line)
  end

  def purchase(attributes)
    purchase = find_or_initializer(Integration::Purchases::Purchase, attributes)
    purchase.manager = Integration::Supports::ManagementUnit.find_by(codigo: attributes[:unidade_gestora])
    purchase
  end

  def find_or_initializer(model, attributes)
    model.find_or_initialize_by(
      numero_publicacao: attributes[:numero_publicacao],
      numero_viproc: attributes[:numero_viproc],
      num_termo_participacao: attributes[:num_termo_participacao],
      codigo_item: attributes[:codigo_item]
    )
  end

  def message
    default_message.merge({
      mes: reference_month.month,
      ano: reference_month.year
    })
  end

  def configuration_class
    Integration::Purchases::Configuration
  end
end
